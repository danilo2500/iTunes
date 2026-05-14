//
//  AlbumView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 10/05/26.
//

import SwiftUI

struct AlbumView: View {
    
    let collectionID: Int
    let showHeader: Bool
    let isInspector: Bool

    @Binding var path: NavigationPath
    @Environment(PlayerViewModel.self) private var playerViewModel
    @State var albumViewModel = AlbumViewModel()
    
    var body: some View {
        List {
            Section {
                ForEach(albumViewModel.songs, id: \.self) { song in
                    Button {
                        playerViewModel.configure(with: song, albumSongs: albumViewModel.songs)
                        if !isInspector {
                            path.removeLast()
                        }
                    } label: {
                        HStack {
                            Label {
                                Text(song.displayName)
                                Text(song.artistName)
                            } icon: {
                            AppAsyncImage(url: song.artworkUrl100) { image in
                                image
                                    .frame(width: 44, height: 44)
                                    .clipShape(.rect(cornerRadius: 8))
                            }
                            .accessibilityHidden(true)
                            }
                            .lineLimit(1)
                            .labelReservedIconWidth(52)
                            Spacer()
                            if song.trackId == playerViewModel.currentSong?.trackId {
                                Image(systemName: "lines.measurement.horizontal")
                                    .symbolEffect(.variableColor.iterative.hideInactiveLayers.nonReversing, options: .repeat(.continuous))
                                    .accessibilityLabel("Now Playing")
                            }
                        }
                    }
                    .accessibilityLabel("Play \(song.displayName) by \(song.artistName)")
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            } header: {
                if showHeader {
                    if let album = albumViewModel.album {
                        VStack {
                            AppAsyncImage(url: album.artworkUrl100) { image in
                                image
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .clipShape(.rect(cornerRadius: 20))
                            }
                            .accessibilityHidden(true)
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
        }
        .refreshable {
            await albumViewModel.fetchSongs(collectionID: collectionID)
        }
        .tint(Color(.label))
        .overlay {
            if albumViewModel.isLoading {
                ProgressView()
                    .controlSize(.extraLarge)
                    .accessibilityLabel("Loading album")
            } else if let error = albumViewModel.error {
                ContentUnavailableView {
                    Label(error.localizedDescription, systemImage: "exclamationmark.triangle")
                } actions: {
                    Button("Retry") {
                        Task {
                            await albumViewModel.fetchSongs(collectionID: collectionID)
                        }
                    }
                }
            } else if albumViewModel.songs.isEmpty {
                ContentUnavailableView("No Songs Found", systemImage: "music.note.slash")
            }
        }
        .task {
            await albumViewModel.fetchSongs(collectionID: collectionID)
        }
    }
}

#Preview {
    AlbumView(collectionID: 617154241, showHeader: true, isInspector: false, path: .constant(NavigationPath()))
        .environment(PlayerViewModel())
}
