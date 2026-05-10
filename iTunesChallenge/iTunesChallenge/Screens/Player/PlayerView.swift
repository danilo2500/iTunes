//
//  PlayerView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 10/05/26.
//

import SwiftUI

struct PlayerView: View {
    
    let song: ITunesSong
    @State private var viewModel = PlayerViewModel()
    @State var showActionSheet = false
    
    var body: some View {
        VStack {
            Spacer()
            AsyncImage(url: song.artworkUrl100) { image in
                switch image {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 32))
                        .frame(maxWidth: 264)
                default:
                    Image(systemName: "photo")
                }
            }
            Spacer()
            VStack(spacing: 24) {
                PlaybackHeader(trackName: song.trackName, artistName: song.artistName, isRepeating: $viewModel.isRepeating)
                SliderView(progress: $viewModel.progress) { isEditing in
                    print("isEditing", isEditing)
                    viewModel.isScrubbing = isEditing
                } minimumValueLabel: {
                    Text(Duration.seconds(viewModel.currentTime), format: .time(pattern: .minuteSecond))
                } maximumValueLabel: {
                    Text(Duration.seconds(viewModel.remainingTime), format: .time(pattern: .minuteSecond))
                }
                PlaybackControlsView(isPlaying: $viewModel.isPlaying)
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(song.artistName)
        .onAppear {
            viewModel.load(url: song.previewUrl)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showActionSheet = true
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .sheet(isPresented: $showActionSheet) {
            PlayerActionSheet(trackName: song.trackName, artistName: song.artistName)
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
        PlayerView(song: .mock)
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
