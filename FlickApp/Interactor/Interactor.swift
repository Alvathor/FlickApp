//
//  Interactor.swift
//  FlickApp
//
//  Created by Juliano Alvarenga on 30/05/24.
//

import Foundation
import OSLog

enum InteractorTypes {
    case interacting(Interacting)
    case mockInteracting(Interacting)

    var value: Interacting {
        switch self {
        case .interacting(let interactor):
            return interactor
        case .mockInteracting(let interactor):
            return interactor
        }
    }
}

protocol Interacting {
    func searchImages(with searchTerm: String) async throws -> FlickImage
}

class Interactor: Interacting {

    let interactorLog = Logger(subsystem: "FlickApp", category: "Interactor")

    enum Errors: Error {
        case failSearchingImage
        case failtConstructingUrl
    }

    func searchImages(with searchTerm: String) async throws -> FlickImage {
        let urlTring = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(searchTerm)"
        guard let url = URL(string: urlTring) else {
            throw Errors.failtConstructingUrl
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let images = try JSONDecoder().decode(FlickImage.self, from: data)
            return images
        } catch {
            interactorLog.error("fail to fetch images form flicks api with error \(error)")
            throw Errors.failSearchingImage
        }
    }
}

class MockInteractor: Interacting {
    
    var items = [Item]()

    func searchImages(with searchTerm: String) async throws -> FlickImage {
        makeItems()
        return .init(
            title: "",
            link: "",
            description: "",
            modified: "",
            generator: "",
            items: items
        )
    }

    private func makeItems() {
        (0..<20).forEach { index in
            items.append(
                .init(
                    title: "Title \(index)",
                    link: "",
                    media: .init(m: ""),
                    dateTaken: "",
                    description: "Description \(index)",
                    published: "2024-05-29T21:\(index):06Z",
                    author: "alvarenga\(index).vix@gmail.com (\"Juliano Alvarenga\")",
                    authorID: "\(index)-123",
                    tags: ""
                )
            )
        }
    }

}
