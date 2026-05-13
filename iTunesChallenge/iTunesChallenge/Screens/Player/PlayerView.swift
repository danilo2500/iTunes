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
            if let song = viewModel.currentSong {
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
                    PlaybackHeader(trackName: song.displayName, artistName: song.artistName, isRepeating: Bindable(viewModel).isRepeating)
                    SliderView(progress: Bindable(viewModel).progress) { isEditing in
                        viewModel.isScrubbing = isEditing
                    } minimumValueLabel: {
                        Text(Duration.seconds(viewModel.currentTime), format: .time(pattern: .minuteSecond))
                    } maximumValueLabel: {
                        Text(Duration.seconds(viewModel.remainingTime), format: .time(pattern: .minuteSecond))
                    }
                    PlaybackControlsView()
                }
                .disabled(viewModel.isPlaybackControlsDisabled)
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.currentSong?.artistName ?? "")
        .onDisappear {
            if let currentSong = viewModel.currentSong {
                viewModel.persistSongMetadata(currentSong, modelContext: modelContext)
            }
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
                collectionID: viewModel.currentSong?.collectionId ?? 0,
                showHeader: false,
                isInspector: true,
                path: $path
            )
            .inspectorColumnWidth(280)
        }
    }
}



struct PlaybackControlsView: View {
    @Environment(PlayerViewModel.self) private var playerViewModel
    
    var body: some View {
        
        HStack {
            Spacer()
            HStack(spacing: 28) {
                Button {
                    playerViewModel.returnToPreviousSong()
                } label: {
                    Image(systemName: "backward.end.alt.fill")
                }
                .disabled(!playerViewModel.hasPrevious)
                Button {
                    playerViewModel.isPlaying.toggle()
                } label: {
                    Image(systemName: playerViewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title)
                        .padding()
                        .contentTransition(.symbolEffect(.replace))
                        .glassEffect()
                }
                Button {
                    playerViewModel.goToNextSong()
                } label: {
                    Image(systemName: "forward.end.alt.fill")
                }
                .disabled(!playerViewModel.hasNext)
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
