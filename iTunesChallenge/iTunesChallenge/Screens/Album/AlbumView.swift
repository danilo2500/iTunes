//
//  AlbumView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 10/05/26.
//

import SwiftUI

struct AlbumView: View {
    
    let albumID: Int
    
    @State var viewModel = AlbumViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.songs) { song in
                        Label {
                            Text(song.trackName)
                            Text(song.artistName)
                        } icon: {
                            AsyncImage(url: song.artworkUrl100)
                                .frame(width: 44, height: 44)
                                .clipShape(.rect(cornerRadius: 8))
                        }
                        .lineLimit(1)
                        .labelReservedIconWidth(52)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                } header: {
                    VStack {
                        Image("musical-note")
                        Text("Album Title")
                            .font(.title3)
                        Text("Daft Punk")
                            .font(.footnote)
                    }
                    .foregroundStyle(Color(.label))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 48)
                }
            }

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
//                                await viewModel.fetchSongs(albumID: )
                            }
                        }
                    }
                } else if viewModel.songs.isEmpty {
                    ContentUnavailableView("", systemImage: "music.note", description: Text("Songs that you search or add will appear here"))
                }
            }
            .task {
//                await viewModel.search(query: searchText)
            }
        }
    }
}

#Preview {
    AlbumView(albumID: 617154241)
}



//

import Foundation

@Observable
final class AlbumViewModel {
    
    var songs: [ITunesSong] = [.mock]
    var isLoading = false
    var error: Error?
    
    //MARK: - Private Variables
    
    private let itunesService: ItunesServiceProtocol

    //MARK: - Init
    
    init(itunesService: ItunesServiceProtocol = ItunesService()) {
        self.itunesService = itunesService
    }
    
    //MARK: - Functions
    
    //MARK: - Private Functions
    
    func fetchSongs(albumID: String) async {
        isLoading = true
        defer { isLoading = false }
        
//        do {
//            let response = try await itunesService.fetchSongs(query: query)
//            songs = response.results
//        } catch {
//            self.error = error
//        }
    }
}



