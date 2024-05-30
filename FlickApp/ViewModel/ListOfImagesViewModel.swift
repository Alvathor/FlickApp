//
//  ListOfImagesViewModel.swift
//  FlickApp
//
//  Created by Juliano Alvarenga on 30/05/24.
//

import Foundation
import Observation

@Observable
class ListOfImagesViewModel {

    var searchTerm = ""
    var images = [DataModel]()
    
    var state: OprationState = .notStarted
    private let interactor: Interacting

    init(interactor: InteractorTypes = .interacting(Interactor())) {
        self.interactor = interactor.value
    }

    func searchImages() async {
        state = .loading
        do {
            let fetchedImages = try await interactor.searchImages(with: searchTerm)
            await MainActor.run {
                images = fetchedImages.items.map(makeDataModel(_:))
                state = .success
            }

        } catch {
            await MainActor.run {
                state = .failure
            }
        }
    }

    func makeDataModel(_ item: Item) -> DataModel {
        .init(
            title: item.title,
            description: item.description,
            author: item.author,
            publishedDate: item.published,
            tags: item.tags,
            image: item.media.m
        )
    }

    struct DataModel: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let description: String
        let author: String
        let publishedDate: String
        let tags: String
        let image: String
    }
}
