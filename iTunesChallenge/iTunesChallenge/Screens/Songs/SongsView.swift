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
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .controlSize(.extraLarge)
            case .error(let message):
                ContentUnavailableView {
                    Label(message, systemImage: "exclamationmark.triangle")
                } actions: {
                    Button("Retry") {
                        Task {
                            await viewModel.searchDebounced()
                        }
                    }
                }
            case .idle:
                ContentUnavailableView("No Songs yet", systemImage: "music.note", description: Text("recent songs will appear here"))
            case .loaded:
                EmptyView()
            }
        }
        .navigationTitle("Songs")
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer, prompt: "Search")
        .task(id: viewModel.searchText) {
            await viewModel.searchDebounced()
        }
        .onChange(of: cachedSongs, initial: true) { _, newValue in viewModel.updateCachedSongs(newValue) }
    }
}



#Preview {
    SongsView(path: .constant(NavigationPath()))
        .environment(PlayerViewModel())
}
