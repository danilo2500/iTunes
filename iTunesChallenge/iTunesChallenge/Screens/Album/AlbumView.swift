//
//  AlbumView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 10/05/26.
//

import SwiftUI

struct AlbumView: View {
    
    let collectionID: Int
    
    @Binding var path: NavigationPath
    @State var viewModel = AlbumViewModel()
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.songs, id: \.self) { song in
                    Button {
                        path.removeLast(path.count)
                        path.append(song)
                    } label: {
                        Label {
                            Text(song.displayName)
                            Text(song.artistName)
                        } icon: {
                            AsyncImage(url: song.artworkUrl100)
                                .frame(width: 44, height: 44)
                                .clipShape(.rect(cornerRadius: 8))
                        }
                        .lineLimit(1)
                        .labelReservedIconWidth(52)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            } header: {
                if let album = viewModel.album {
                    VStack {
                        AsyncImage(url: album.artworkUrl100)
                            .frame(width: 120, height: 120)
                            .clipShape(.rect(cornerRadius: 20))
                        Text(album.collectionName)
                            .font(.title3)
                        Text(album.artistName)
                            .font(.footnote)
                    }
                    .foregroundStyle(Color(.label))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 48)
                }
            }
        }
        .tint(Color(.label))
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .controlSize(.extraLarge)
            } else if let error = viewModel.error {
                ContentUnavailableView {
                    Label(error.localizedDescription, systemImage: "exclamationmark.triangle")
                } actions: {
                    Button("Retry") {
                        Task {
                            await viewModel.fetchSongs(collectionID: collectionID)
                        }
                    }
                }
            } else if viewModel.songs.isEmpty {
                ContentUnavailableView("No Songs Found", systemImage: "music.note.slash")
            }
        }
        .task {
            await viewModel.fetchSongs(collectionID: collectionID)
        }
    }
}

#Preview {
    AlbumView(collectionID: 617154241, path: .constant(NavigationPath()))
}

import Foundation

@Observable
final class AlbumViewModel {
    
    var songs: [ITunesMedia] = []
    var album: ITunesMedia? {
        songs.first { $0.wrapperType == .collection }
    }
    var isLoading = false
    var error: Error?
    
    //MARK: - Private Variables
    
    private let itunesService: ItunesServiceProtocol
    
    //MARK: - Init
    
    init(itunesService: ItunesServiceProtocol = ItunesService()) {
        self.itunesService = itunesService
    }
    
    //MARK: - Functions
    
    func fetchSongs(collectionID: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await itunesService.fetchCollection(id: collectionID)
            songs = response.results
        } catch {
            print(error)
            self.error = error
        }
    }
}



