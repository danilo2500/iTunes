//
//  SongsView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 09/05/26.
//

import SwiftUI
import SwiftData

struct SongsView: View {
    
    @State var viewModel = SongsViewModel()
    @Environment(PlayerViewModel.self) private var playerViewModel
    
    @State var searchText = ""
    @Binding var path: NavigationPath
    
    @Query var cachedSongs: [CachedSong]
    
    var body: some View {
        List {
            ForEach(viewModel.songs, id: \.self.trackId) { song in
                Button {
                    playerViewModel.configure(with: song)
                    path.append(AppDestination.player)
                } label: {
                    SongListRow(trackName: song.displayName, artistName: song.artistName, artworkUrl: song.artworkUrl100, collectionId: song.collectionId, path: $path)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            if !cachedSongs.isEmpty {
                Section("Recently Played") {
                    ForEach(cachedSongs, id: \.self) { song in
                        Button {
                            playerViewModel.configure(with: song.asPlayableMedia)
                            path.append(AppDestination.player)
                        } label: {
                            SongListRow(trackName: song.trackName ?? song.collectionName, artistName: song.artistName, artworkUrl: song.artworkUrl100, collectionId: song.collectionId, path: $path)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
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
                            await viewModel.search(query: searchText)
                        }
                    }
                }
            } else if (viewModel.songs + cachedSongs.map(\.asPlayableMedia)).isEmpty {
                ContentUnavailableView("No Songs yet", systemImage: "music.note", description: Text("recent songs will appear here"))
            }
        }
        .navigationTitle("Songs")
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search")
        .task(id: searchText) {
            try? await Task.sleep(for: .milliseconds(500))
            if Task.isCancelled { return }
            await viewModel.search(query: searchText)
        }
    }
}



#Preview {
    SongsView(path: .constant(NavigationPath()))
        .environment(PlayerViewModel())
}
