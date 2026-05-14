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
                .accessibilityHidden(true)
                Spacer()
                VStack(spacing: 24) {
                    let durationFormat = Duration.UnitsFormatStyle(allowedUnits: [.seconds], width: .wide)
                    PlaybackHeader(trackName: song.displayName, artistName: song.artistName, isRepeating: Bindable(viewModel).isRepeating)
                    SliderView(progress: Bindable(viewModel).progress, totalDuration: viewModel.totalDuration) { isEditing in
                        viewModel.isScrubbing = isEditing
                    } minimumValueLabel: {
                        Text(Duration.seconds(viewModel.currentTime), format: .time(pattern: .minuteSecond))
                            .accessibilityLabel(Duration.seconds(viewModel.currentTime).formatted(durationFormat))
                    } maximumValueLabel: {
                        Text(Duration.seconds(viewModel.remainingTime), format: .time(pattern: .minuteSecond))
                            .accessibilityLabel(Duration.seconds(abs(viewModel.remainingTime)).formatted(durationFormat) + " remaining")
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
                    Button("Playlist", systemImage: "music.note.list") {
                        showInspector.toggle()
                    }
                    .labelStyle(.iconOnly)
                }
            }
            ToolbarSpacer()
            ToolbarItem {
                Button("More Actions", systemImage: "ellipsis") {
                    showActionSheet = true
                }
                .labelStyle(.iconOnly)
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
                Button(isRepeating ? "Repeat One" : "Repeat All", systemImage: isRepeating ? "repeat.1" : "repeat") {
                    isRepeating.toggle()
                }
                .labelStyle(.iconOnly)
                .symbolEffect(.bounce, value: isRepeating)
                .foregroundStyle(Color(.label))
            } label: {
                Text(artistName)
                    .font(.headline.bold())
                    .opacity(0.7)
            }
        }
    }
}
