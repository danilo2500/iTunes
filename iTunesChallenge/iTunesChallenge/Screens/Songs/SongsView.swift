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
                } else {
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
