//
//  ImageDetailViewModel.swift
//  FlickApp
//
//  Created by Juliano Alvarenga on 30/05/24.
//

import Foundation
import Observation

@Observable
class ImageDetailViewModel {
    typealias ImageDataModel = ListOfImagesViewModel.DataModel

    var dataModel: DataModel = .init(image: "", title: "", description: "", authorName: "", authorEmail: "", formatedPublishedDate: .now)

    init(image: ImageDataModel) {
        makeDataModel(with: image)
    }


    func makeDataModel(with image: ImageDataModel) {
        let author = parseAuthor(with: image)
        dataModel = .init(
            image: image.image,
            title: image.title,
            description: image.description.htmlToString,
            authorName: author.name,
            authorEmail: author.email,
            formatedPublishedDate: formateDate(with: image.publishedDate)
        )
    }

    struct Author {
        let name: String
        let email: String
    }

    func formateDate(with dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateString)!
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        return finalDate ?? .now
    }


//    func formateDate(with dateString: String) -> Date {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        formatter.dateStyle = .medium
////        formatter.timeZone = .current
//        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure test consistency by setting time zone
//
//        return formatter.date(from: dateString) ?? Date()
//    }

    func parseAuthor(with image: ImageDataModel) -> Author {
        let parts = image.author.components(separatedBy: " (\"")

        guard parts.count == 2 else {
            return .init(name: "", email: "")
        }

        let email = parts[0]
        let name = parts[1].trimmingCharacters(in: CharacterSet(charactersIn: "\")"))

        return .init(name: name, email: email)
    }

    struct DataModel {
        var image: String
        var title: String
        var description: String
        var authorName: String
        var authorEmail: String
        let formatedPublishedDate: Date
    }
}
