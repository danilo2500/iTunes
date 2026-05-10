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
    
    @State var songProgress = 0.0
    @State private var isScrubbing = false
    
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
                VStack(alignment: .leading, spacing: 4) {
                    Text(song.trackName)
                        .font(.largeTitle.bold())
                    LabeledContent {
                        Button {
                            viewModel.isRepeating.toggle()
                        } label: {
                            Image(systemName: viewModel.isRepeating ? "repeat.1" : "repeat")
                                .symbolEffect(.bounce, value: viewModel.isRepeating)
                        }
                        .foregroundStyle(.white)
                    } label: {
                        Text(song.artistName)
                            .font(.headline.bold())
                            .opacity(0.7)
                    }
                }
                SliderView(progress: $songProgress) { isEditing in
                    if isEditing {
                        isScrubbing = true
                    } else {
                        viewModel.seek(to: songProgress) {
                            isScrubbing = false
                        }
                    }
                } minimumValueLabel: {
                    Text("vai")
                } maximumValueLabel: {
                    Text("vai")
                }
                PlaybackControlsView(isPlaying: $viewModel.isPlaying)
            }
        }
        .padding()
        .onChange(of: viewModel.isPlaying) { _, newValue in
            if newValue {
                viewModel.play(url: song.previewUrl) { progress in
                    if !isScrubbing  {
                        songProgress = progress
                    }
                }
            } else {
                viewModel.pause()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(song.artistName)
    }
}

import SwiftUI

struct PlaybackControlsView: View {
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

struct SliderView<MaxMinLabel: View>: View {
    
    @Binding var progress: Double
    
    let totalFrameHeight: CGFloat = 24
    let thumbSize: CGFloat = 24
    let sliderHeight: CGFloat = 8
    
    var onEditingChanged: (Bool) -> Void = { _ in }
    
    @ViewBuilder let minimumValueLabel: () -> MaxMinLabel
    @ViewBuilder let maximumValueLabel: () -> MaxMinLabel
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                let trackWidth = proxy.size.width - thumbSize
                let offset = thumbSize / 2 + trackWidth * progress
                Slider(value: $progress) { isEditing in
                    onEditingChanged(isEditing)
                }
                .sliderThumbVisibility(.hidden)
                .tint(.gray)
                .overlay {
                    Circle()
                        .frame(width: thumbSize, height: thumbSize)
                        .position(x: offset, y: (totalFrameHeight + sliderHeight) / 2)
                        .allowsHitTesting(false)
                }
            }
            .frame(height: totalFrameHeight)
            HStack {
                minimumValueLabel()
                Spacer()
                maximumValueLabel()
            }
            .opacity(0.7)
            .font(.footnote)
        }
    }
}

import AVFoundation

@Observable
class PlayerViewModel {
    var isRepeating = false
    var isPlaying = false

    private var player: AVPlayer?
    private var endObserver: Any?

    func play(url: URL, onProgress: @escaping (Double) -> Void) {
        if player == nil {
            player = AVPlayer(url: url)
            observeProgress(update: onProgress)
            observeEnd()
        }
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player = nil
    }
    
    func seek(to progress: Double, completion: @escaping () -> Void = {}) {
        guard let duration = player?.currentItem?.duration else { return }
        let seconds = duration.seconds * progress
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        player?.seek(to: time) { _ in
            completion()
        }
    }
    
    private func observeProgress(update: @escaping (Double) -> Void) {
        let interval = CMTime(seconds: 0.2, preferredTimescale: 600)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let duration = self?.player?.currentItem?.duration.seconds,
                  duration > 0 else { return }
            update(time.seconds / duration)
        }
    }
    
    private func observeEnd() {
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.player?.seek(to: .zero)
            if isRepeating {
                self.player?.play()
            } else {
                isPlaying = false
            }
         
        }
    }
}
