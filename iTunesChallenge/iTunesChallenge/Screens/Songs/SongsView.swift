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
                songRow(for: song)
            }
            if !cachedSongs.isEmpty {
                Section("Recently Played") {
                    ForEach(cachedSongs, id: \.self) { song in
                        songRow(for: song.asPlayableMedia)
                    }
                }
            }
        }
        .refreshable {
            await viewModel.searchDebounced()
        }
        .overlay {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .controlSize(.extraLarge)
                    .accessibilityLabel("Loading songs")
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
        .onChange(of: cachedSongs, initial: true) { _, newValue in
            viewModel.cachedSongs = newValue.map(\.asPlayableMedia)
        }
    }

    private func songRow(for media: PlayableMedia) -> some View {
        Button {
            playerViewModel.configure(with: media)
            path.append(AppDestination.player)
        } label: {
            SongListRow(trackName: media.displayName, artistName: media.artistName, artworkUrl: media.artworkUrl100, collectionId: media.collectionId, path: $path)
        }
        .accessibilityLabel("Play \(media.displayName) by \(media.artistName)")
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}



#Preview {
    SongsView(path: .constant(NavigationPath()))
        .environment(PlayerViewModel())
}
