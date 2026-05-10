//
//  PlayerView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 10/05/26.
//

import SwiftUI

struct PlayerView: View {
    
    let song: ITunesSong
    @State private var audioPlayer = AudioPlayer()
    
    @State var songPosition = 0.0
    @State var isPlaying = false
    
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
                        Image(systemName: "repeat")
                            .foregroundStyle(.white)
                    } label: {
                        Text(song.artistName)
                            .font(.headline.bold())
                            .opacity(0.7)
                    }
                }
                SliderView(value: $songPosition) {
                    Text("vai")
                } maximumValueLabel: {
                    Text("toma")
                }
                ZStack {
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
                }
            }
        }
        .padding()
        .onChange(of: isPlaying) { _, newValue in
            if newValue {
                audioPlayer.play(url: song.previewUrl) { progress in
                    songPosition = progress
                }
            } else {
                audioPlayer.pause()
            }
        }
    }
}

#Preview {
    PlayerView(song: .mock)
}

import SwiftUI

struct SliderView<MaxMinLabel: View>: View {
    
    @Binding var value: Double
    
    let totalFrameHeight: CGFloat = 24
    let thumbSize: CGFloat = 24
    let sliderHeight: CGFloat = 8
    
    @ViewBuilder let minimumValueLabel: () -> MaxMinLabel
    @ViewBuilder let maximumValueLabel: () -> MaxMinLabel
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                let trackWidth = proxy.size.width - thumbSize
                let offset = thumbSize / 2 + trackWidth * value
                
                Slider(value: $value)
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
        .animation(.default, value: value)
    }
}

import AVFoundation

@Observable
class AudioPlayer {
    private var player: AVPlayer?
    
    func play(url: URL, onProgress: @escaping (Double) -> Void) {
        if player == nil {
            player = AVPlayer(url: url)
            observeProgress(update: onProgress)
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

    private func observeProgress(update: @escaping (Double) -> Void) {
        let interval = CMTime(seconds: 0.2, preferredTimescale: 600)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let duration = self?.player?.currentItem?.duration.seconds,
                  duration > 0 else { return }
            update(time.seconds / duration)
        }
    }
}
