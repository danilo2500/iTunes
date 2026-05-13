//
//  PlayerView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 10/05/26.
//

import SwiftUI
import SwiftData

struct PlayerView: View {
    
    @Binding var path: NavigationPath
    @Environment(PlayerViewModel.self) private var viewModel
    @State var showActionSheet = false
    @State var showInspector = true
    @Environment(\.modelContext) private var modelContext
    
    init(path: Binding<NavigationPath>) {
        self._path = path
    }
    
    var body: some View {
        VStack {
            Spacer()
            AppAsyncImage(url: viewModel.currentSong.artworkUrl100) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 32))
                    .frame(maxWidth: 264)
            }
            Spacer()
            VStack(spacing: 24) {
                PlaybackHeader(trackName: viewModel.currentSong.displayName, artistName: viewModel.currentSong.artistName, isRepeating: Bindable(viewModel).isRepeating)
                SliderView(progress: Bindable(viewModel).progress) { isEditing in
                    viewModel.isScrubbing = isEditing
                } minimumValueLabel: {
                    Text(Duration.seconds(viewModel.currentTime), format: .time(pattern: .minuteSecond))
                } maximumValueLabel: {
                    Text(Duration.seconds(viewModel.remainingTime), format: .time(pattern: .minuteSecond))
                }
                PlaybackControlsView(
                    isPlaying: Bindable(viewModel).isPlaying,
                    onPrevious: viewModel.returnToPreviousSong,
                    onNext: viewModel.goToNextSong,
                    isPreviousDisabled: !viewModel.hasPrevious,
                    isNextDisabled: !viewModel.hasNext
                )
            }
            .disabled(viewModel.isPlaybackControlsDisabled)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.currentSong.artistName)
        .onDisappear {
            viewModel.persistSongMetadata(viewModel.currentSong, modelContext: modelContext)
            viewModel.stop()
        }
        .toolbar {
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            if isIPad {
                ToolbarItem {
                    Button {
                        showInspector.toggle()
                    } label: {
                        Image(systemName: "music.note.list")
                    }
                }
            }
            ToolbarSpacer()
            ToolbarItem {
                Button {
                    showActionSheet = true
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .sheet(isPresented: $showActionSheet) {
            PlayerActionSheet(path: $path)
        }
        .inspector(isPresented: $showInspector) {
            AlbumView(
                collectionID: viewModel.currentSong.collectionId,
                showHeader: false,
                isInspector: true,
                path: $path
            )
            .inspectorColumnWidth(280)
        }
    }
}



fileprivate struct PlaybackControlsView: View {
    @Binding var isPlaying: Bool
    let onPrevious: (() -> Void)
    let onNext: (() -> Void)
    var isPreviousDisabled: Bool
    var isNextDisabled: Bool
    
    var body: some View {
        
        HStack {
            Spacer()
            HStack(spacing: 28) {
                Button {
                    onPrevious()
                } label: {
                    Image(systemName: "backward.end.alt.fill")
                }
                .disabled(isPreviousDisabled)
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
                    onNext()
                } label: {
                    Image(systemName: "forward.end.alt.fill")
                }
                .disabled(isNextDisabled)
            }
            .tint(Color(.label))
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        PlayerView(path: .constant(NavigationPath()))
            .environment(PlayerViewModel())
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
