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
    
    @State var searchText = ""
    @Binding var path: NavigationPath
    
    @Query var cachedSongs: [CachedSong]
    
    var body: some View {
        List {
            ForEach(viewModel.songs, id: \.self) { song in
                Button {
                    path.append(song)
                } label: {
                    SongListRow(trackName: song.displayName, artistName: song.artistName, artworkUrl: song.artworkUrl100)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            Section("Recently Played") {
                ForEach(cachedSongs, id: \.self) { cachedSong in
                    Button {
                        path.append(cachedSong.asITunesMedia)
                    } label: {
                        SongListRow(trackName: cachedSong.trackName ?? cachedSong.collectionName, artistName: cachedSong.artistName, artworkUrl: cachedSong.artworkUrl100)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
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
            } else if !searchText.isEmpty && viewModel.songs.isEmpty {
                ContentUnavailableView.search
            } else if searchText.isEmpty && cachedSongs.isEmpty {
                ContentUnavailableView("", systemImage: "music.note", description: Text("Songs that you search or add will appear here"))
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
}
