//
//  ImageDetailView.swift
//  FlickApp
//
//  Created by Juliano Alvarenga on 29/05/24.
//

import SwiftUI

struct ImageDetailView: View {
    typealias DataModel = ListOfImagesViewModel.DataModel
    @Bindable var viewModel: ImageDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var offSet: CGPoint = .zero
    @State private var progress: CGFloat = 1
    var body: some View {
        GeometryReader { geo in
            OffsetObservingScrollView(offset: $offSet) {
                VStack(spacing: 16) {
                    makeBackdropView(with: geo)
                    VStack(spacing: 16) {
                        HStack {
                            posterView
                            headerInfoView
                            Spacer()
                        }
                        Text(viewModel.dataModel.description)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    .padding()
                    .offset(y: -100)
                }
                .frame(width: geo.size.width)
                .onChange(of: offSet) { oldValue, newValue in
                    progress = 1 - offSet.y * 0.001
                }
            }
            .navigationTitle(viewModel.dataModel.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func openEmailClient(with email: String) {
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: View Components
extension ImageDetailView {

    @ViewBuilder
    private func makeBackdropView(with geo: GeometryProxy) -> some View {
        ZStack {
            AsyncCachedImageView(
                urlString: viewModel.dataModel.image,
                data: nil,
                size: .init(width: geo.size.width, height: geo.size.width),
                aspect: .fill
            )
            .scaleEffect(offSet.y < 0 ? progress : 1)
            .frame(height: geo.size.width)
            .offset(y: offSet.y)
            Rectangle()
                .foregroundStyle(
                    LinearGradient(colors: [.clear,.black, .blackAndWhite], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: geo.size.width, height: geo.size.width)
                .offset(y: geo.size.width / 2 + offSet.y)
        }
    }
    @ViewBuilder
    private var posterView: some View {
        AsyncCachedImageView(
            urlString: viewModel.dataModel.image,
            data: nil,
            size: .init(
                width: 100,
                height: 100
            ), aspect: .fill
        )
        .clipShape(Circle())
    }

    private var headerInfoView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.dataModel.title)
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(2)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "camera.fill")
                        .foregroundStyle(.pink)
                        .font(.subheadline)
                    Text(viewModel.dataModel.authorName)
                        .font(.caption)
                        .foregroundColor(.title)
                }
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundStyle(.blue)
                        .font(.subheadline)
                    Button(action: {
                        openEmailClient(with: viewModel.dataModel.authorEmail)
                    }, label: {
                        Text(viewModel.dataModel.authorEmail)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    })
                }
            }


            Text("Published: \(viewModel.dataModel.formatedPublishedDate, style: .date)")
                .foregroundStyle(.secondary)
                .font(.footnote)
        }
    }
}
