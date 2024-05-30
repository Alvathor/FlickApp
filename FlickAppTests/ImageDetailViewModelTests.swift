//
//  ImageDetailViewModelTests.swift
//  FlickAppTests
//
//  Created by Juliano Alvarenga on 30/05/24.
//

import XCTest
@testable import FlickApp

final class ImageDetailViewModelTests: XCTestCase {
    
    var sut: ImageDetailViewModel!
    var sampleImage: ListOfImagesViewModel.DataModel!

    override func setUp() async throws {
        sampleImage = makeSampleImage()
        sut = ImageDetailViewModel(image: sampleImage)
    }

    override func tearDown() async throws {
        sut = nil
        sampleImage = nil
    }

    func test_makeDataModel_shouldParseDataModelCorrectly() {
        // Act
        sut.makeDataModel(with: sampleImage)

        // Assert
        XCTAssertEqual(sut.dataModel.title, sampleImage.title, "The parsed title should match the sample image title.")
        XCTAssertEqual(sut.dataModel.image, sampleImage.image, "The parsed image URL should match the sample image URL.")
        XCTAssertEqual(sut.dataModel.description.htmlToString.normalizedWhitespace, sampleImage.description.htmlToString.normalizedWhitespace, "The parsed description should match the sample image description after normalizing whitespace.")
    }

    func test_parseAuthor_shouldExtractNameAndEmail() {
        // Act
        let author = sut.parseAuthor(with: sampleImage)

        // Assert
        XCTAssertFalse(author.name.isEmpty, "The extracted author name should not be empty.")
        XCTAssertFalse(author.email.isEmpty, "The extracted author email should not be empty.")
        XCTAssertFalse(author.name.contains("@"), "The extracted author name should not contain '@'.")
        XCTAssertTrue(author.email.contains("@"), "The extracted author email should contain '@'.")
    }

    func test_formateDate_shouldMatchDates()  {
        // Arrange

        let expectedDate = formateDate(with: sampleImage.publishedDate)

        // Act
        let formattedDate = sut.formateDate(with: sampleImage.publishedDate)

        // Assert
        XCTAssertTrue(Calendar.current.isDate(expectedDate, equalTo: formattedDate, toGranularity: .second), "The formatted date should match the expected date to the second.")
          XCTAssertEqual(expectedDate, formattedDate, "The formatted date should match the expected date.")
    }

}

// MARK: Helper
extension ImageDetailViewModelTests {

    func formateDate(with dateString: String) -> Date {
            let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString) ?? .now
    }

    private func makeSampleImage() -> ListOfImagesViewModel.DataModel {
        .init(
            title: "Ensorcellment",
            description: """
   <p><a href=\"https://www.flickr.com/people/188733841@N02/\">Jade Nightraven</a> posted a photo:</p> <p><a href=\"https://www.flickr.com/photos/188733841@N02/53756355375/\" title=\"Ensorcellment\"><img src=\"https://live.staticflickr.com/65535/53756355375_691614d58d_m.jpg\" width=\"240\" height=\"128\" alt=\"Ensorcellment\" /></a></p> <p>Pose and photo created by Jade Nightraven.<br /> <br /> TY Hyo for modeling!!!</p>
   """,
            author: "nobody@flickr.com (\"Jade Nightraven\")",
            publishedDate: "2024-05-29T21:20:06Z",
            tags: "sl secondlife second life mesh lelutka hair long model avatars fashion fantasy 3d animation sexy blogger doll blog blogging event makeup candy dark black skin magic power tattoo colorful different doux glow night tribal electric goth orbs wicked smoke ball harness attention breast powerful casting spell evil sinister surge control conjur ruler destiny craft witchcraft legacy halo fire warlock gothic devious handsome mystical",
            image: "https://live.staticflickr.com/65535/53756355375_691614d58d_m.jpg"
        )
    }
}
