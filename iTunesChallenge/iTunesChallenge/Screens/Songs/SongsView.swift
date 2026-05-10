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
                    HStack(spacing: 16) {
                        Image("musical-note")
                            .resizable()
                            .frame(width: 52, height: 52)
                            .clipShape(.rect(cornerRadius: 8))
                        LabeledContent {
                            Button {
                                
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                            .tint(Color(.secondaryLabel))
                            .popover(isPresented: .constant(false)) {
                                NavigationLink("View Album") {
                                    EmptyView()
                                }
                                .padding()
                                .presentationCompactAdaptation(.popover)
                            }
                            
                        } label: {
                            Text(song.trackName)
                                .font(.callout)
                            Text(song.artistName)
                                .font(.caption)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .controlSize(.extraLarge)
                } else if viewModel.songs.isEmpty {
                    ContentUnavailableView("No songs", systemImage: "music.note.slash", description: Text("Search for an artist or album to see their songs"))
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

