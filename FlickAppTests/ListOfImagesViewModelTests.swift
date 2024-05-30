//
//  ListOfImagesViewModelTests.swift
//  FlickAppTests
//
//  Created by Juliano Alvarenga on 30/05/24.
//

import XCTest
@testable import FlickApp

final class ListOfImagesViewModelTests: XCTestCase {

    var sut: ListOfImagesViewModel!
    var interactor: MockInteractor!

    override func setUp() async throws {
        interactor = MockInteractor()
        sut = ListOfImagesViewModel(interactor: .interacting(interactor))
    }

    override func tearDown() async throws {
        sut = nil
    }

    func test_initialState_shouldBeNotStartedAndEmptySearchTerm() async throws {
        XCTAssertEqual(sut.state, .notStarted, "Initial state should be .notStarted")
        XCTAssertTrue(sut.searchTerm.isEmpty, "Initial search term should be empty")
    }

    func test_searchImages_shouldReturnImagesAndSuccessState() async  throws {
        // Arrange
        sut.searchTerm = "ball"

        // Act
        await sut.searchImages()

        // Assert
        XCTAssertNotEqual(sut.images.count, 0, "Search should return images")
        XCTAssertEqual(sut.state, .success, "State should be .success after search")
    }

    func test_makeDataModel_shouldParseDataModelCorrectly() async throws {
        // Arrange
        typealias DataModel = ListOfImagesViewModel.DataModel
        await sut.searchImages()
        let item = interactor.items[0]
        // Act
        let dataModel = sut.makeDataModel(item)
        
        // Assert
        XCTAssertEqual(dataModel.title, sut.images[0].title, "Data model title should match image title")
        XCTAssertEqual(dataModel.description, sut.images[0].description, "Data model description should match image description")
        XCTAssertEqual(dataModel.image, sut.images[0].image, "Data model image URL should match image URL")
        XCTAssertEqual(dataModel.publishedDate, sut.images[0].publishedDate, "Data model published date should match image published date")
        XCTAssertEqual(dataModel.tags, sut.images[0].tags, "Data model tags should match image tags")
    }

}
