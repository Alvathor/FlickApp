//
//  ListOfImagesView.swift
//  FlickApp
//
//  Created by Juliano Alvarenga on 29/05/24.
//

import SwiftUI

struct ListOfImagesView: View {
    typealias DataModel = ListOfImagesViewModel.DataModel
    @State var viewModel = ListOfImagesViewModel(interactor: .interacting(Interactor()))

    var body: some View {
        NavigationStack {
            if viewModel.state == .success {
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16
                    ) {
                        ForEach(viewModel.images) { image in
                            NavigationLink(value: image) {
                                VStack(alignment: .center, spacing: 4) {
                                    AsyncCachedImageView(
                                        urlString: image.image,
                                        data: nil,
                                        size: .init(width: 150, height: 150),
                                        aspect: .fill
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    infoView(with: image)
                                        .frame(maxWidth: 200)
                                        .redacted(reason: viewModel.state == .loading ? .placeholder : .invalidated)
                                }
                            }
                        }
                    }
                    .navigationDestination(for: DataModel.self, destination: { movie in
                        ImageDetailView(viewModel: .init(image: movie))
                                            .ignoresSafeArea(.container, edges: .top)
                    })
                }
                .padding()
                .navigationTitle("Images")
            } else if viewModel.state == .loading {
                ProgressView()
            }
        }
        .searchable(text: $viewModel.searchTerm)
        .task {
            await viewModel.searchImages()
        }
        .task(id: viewModel.searchTerm, {
            Task { await viewModel.searchImages() }
        })
    }


    @ViewBuilder
    func infoView(with image: DataModel) -> some View {
        Text(image.title)
            .font(.subheadline)
            .fontWeight(.bold)
            .lineLimit(1)
            .foregroundColor(.title)
            .padding(.top, 4)
            Text("(\(image.title))")
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)

    }
}

#Preview {
    ListOfImagesView()
}
