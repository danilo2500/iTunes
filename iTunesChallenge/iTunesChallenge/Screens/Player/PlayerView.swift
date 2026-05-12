//
//  PlayerView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 10/05/26.
//

import SwiftUI
import SwiftData

struct PlayerView: View {
    
    let song: PlayableMedia
    @Binding var path: NavigationPath
    @State private var viewModel = PlayerViewModel()
    @State var showActionSheet = false
    @State var showInspector = true
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            Spacer()
            AppAsyncImage(url: song.artworkUrl100) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 32))
                    .frame(maxWidth: 264)
            }
            Spacer()
            VStack(spacing: 24) {
                PlaybackHeader(trackName: song.displayName, artistName: song.artistName, isRepeating: $viewModel.isRepeating)
                SliderView(progress: $viewModel.progress) { isEditing in
                    viewModel.isScrubbing = isEditing
                } minimumValueLabel: {
                    Text(Duration.seconds(viewModel.currentTime), format: .time(pattern: .minuteSecond))
                } maximumValueLabel: {
                    Text(Duration.seconds(viewModel.remainingTime), format: .time(pattern: .minuteSecond))
                }
                PlaybackControlsView(isPlaying: $viewModel.isPlaying)
            }
            .disabled(viewModel.isPlaybackControlsDisabled)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(song.artistName)
        .onChange(of: song, initial: true) { _, newSong in
            viewModel.load(url: newSong.previewUrl)
        }
        .onDisappear {
            viewModel.persistSongMetadata(song, modelContext: modelContext)
        }
        .toolbar {
            ToolbarItem {
                Button {
                    showInspector.toggle()
                } label: {
                    Image(systemName: "music.note.list")
                }
            }
            ToolbarSpacer()
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            if isIPad {
                ToolbarItem {
                    Button {
                        showActionSheet = true
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
        .sheet(isPresented: $showActionSheet) {
            PlayerActionSheet(trackName: song.displayName, artistName: song.artistName, collectionId: song.collectionId, path: $path)
        }
        .inspector(isPresented: $showInspector) {
            AlbumView(collectionID: song.collectionId, showHeader: false, path: $path)
                .inspectorColumnWidth(280)
        }
    }
}



fileprivate struct PlaybackControlsView: View {
    @Binding var isPlaying: Bool
    
    var body: some View {
        
        HStack {
            Spacer()
            HStack(spacing: 28) {
                Button {
                    
                } label: {
                    Image(systemName: "backward.end.alt.fill")
                }
                Button {
                    isPlaying.toggle()
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.title)
                        .padding()
                        .contentTransition(.symbolEffect(.replace))
                        .glassEffect()
                }
                Button {
                    
                } label: {
                    Image(systemName: "forward.end.alt.fill")
                }
            }
            .tint(Color(.label))
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        PlayerView(song: PlayableMedia.mock, path: .constant(NavigationPath()))
    }
}

import SwiftUI

fileprivate struct PlaybackHeader: View {
    let trackName: String
    let artistName: String
    @Binding var isRepeating: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(trackName)
                .font(.largeTitle.bold())
            LabeledContent {
                Button {
                    isRepeating.toggle()
                } label: {
                    Image(systemName: isRepeating ? "repeat.1" : "repeat")
                        .symbolEffect(.bounce, value: isRepeating)
                }
                .foregroundStyle(Color(.label))
            } label: {
                Text(artistName)
                    .font(.headline.bold())
                    .opacity(0.7)
            }
        }
    }
}
