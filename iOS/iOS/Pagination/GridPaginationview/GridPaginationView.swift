//
//  GridPaginationView.swift
//  iOS
//
//  Created by Abhilash Palem on 03/04/24.
//

import Foundation
import Combine
import SwiftUI

private struct Photo: Decodable, Identifiable {
    let id: String
    let author: String
    let url: String
    let download_url: String
    
    var imageDownloadURL: String {
        "https://picsum.photos/id/\(id)/200/200"
    }
}

@Observable
final class GridPaginationViewModel {
    fileprivate var photos: [Photo] = []
    fileprivate var lastItemID: String?
    
    private let itemsPerPage: Int = 10
    private var nextPageTofetch: Int = 1
    private var allItemsFetched: Bool = false
    
    @ObservationIgnored
    let backButtonClicked = PassthroughSubject<Void, Never>()
    
    func fetchPhotos() {
        Task {
            let urlString = "https://picsum.photos/v2/list?page=\(nextPageTofetch)&limit=\(itemsPerPage)"
            guard let url = URL(string: urlString), !allItemsFetched else {
                return
            }
            do {
                print("Fetching More url: \(urlString)")
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300, let mimeType = response.mimeType, mimeType == "application/json" else {
                    return
                }
                let decoder = JSONDecoder()
                let fetchedPhotos = try decoder.decode([Photo].self, from: data)
                await MainActor.run {
                    if fetchedPhotos.isEmpty {
                        allItemsFetched = true
                        print("Fetch Complete")
                    } else {
                        photos.append(contentsOf: fetchedPhotos)
                        nextPageTofetch += 1
                        lastItemID = fetchedPhotos.last?.id
                        print("Fetch items count: \(fetchedPhotos)")
                    }
                }
            } catch {
                print("Failed to fetch \(error)")
            }
        }
    }
}

struct GridPaginationView: View {
    
    @State private var viewModel: GridPaginationViewModel
    init(vm: GridPaginationViewModel) {
        self._viewModel = State(wrappedValue: vm)
    }
    
    @State private var activeID: String?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10)  {
                ForEach(viewModel.photos) { photo in
                    photoView(photo)
                        .onCallOnceAppear {
                            if photo.id == viewModel.lastItemID {
                                viewModel.fetchPhotos()
                            }
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $activeID, anchor: .bottom)
        .scrollIndicators(.hidden)
        .navigationTitle("Pagination Grid")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text(viewModel.photos.count.description)
                    .font(.title2.bold())
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.fetchPhotos()
        }
        .padding(.horizontal)
        .backButton {
            viewModel.backButtonClicked.send()
        }
    }
    
    private func photoView(_ photo: Photo) -> some View {
        VStack(alignment: .leading) {
            GeometryReader { proxy in
                let size = proxy.size
                AsyncImage(url: URL(string: photo.imageDownloadURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                } placeholder: {
                    ProgressView()
                        .frame(width: size.width, height: size.height)

                }
            }
            .frame(height: 120)
            
            Text(photo.author)
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
                .textScale(.secondary)
        }
    }
}

extension View {
    func onCallOnceAppear(_ action: @escaping () -> Void) -> some View {
        modifier(CallOnceOnAppear(action: action))
    }
}


private struct CallOnceOnAppear: ViewModifier {
    @State private var triggered: Bool = false
    let action: () -> Void
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !triggered {
                    action()
                    triggered.toggle()
                }
            }
    }
}

#Preview {
    GridPaginationView(vm: .init())
}
