//
//  SongsView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 09/05/26.
//

import SwiftUI

struct SongsView: View {
    
    @State var viewModel = SongsViewModel()
    
    @State var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.songs) { song in
                    NavigationLink {
                        
                    } label: {
                        SongListRow(trackName: song.trackName, artistName: song.artistName, artworkUrl: song.artworkUrl100)
                    }
                    .listRowBackground(Color.clear)
                    .navigationLinkIndicatorVisibility(.hidden)
                    .listRowSeparator(.hidden)
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
                } else if viewModel.songs.isEmpty {
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
}



#Preview {
    SongsView()
}
