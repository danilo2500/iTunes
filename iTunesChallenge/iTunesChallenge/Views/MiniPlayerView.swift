//
//  MiniPlayerView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 13/05/26.
//



import SwiftUI

struct MiniPlayerView: View {
    @Environment(PlayerViewModel.self) private var playerViewModel
    
    var body: some View {
        if let currentSong = playerViewModel.currentSong {
            LabeledContent {
                PlaybackControlsView()
                    .fixedSize()
            } label: {
                HStack {
                    AppAsyncImage(url: currentSong.artworkUrl100) { image in
                        image
                            .resizable()
                            .frame(width: 44, height: 44)
                            .clipShape(.rect(cornerRadius: 8))
                    }
                    VStack(alignment: .leading) {
                        Text(currentSong.displayName)
                            .font(.callout)
                        Text(currentSong.collectionName)
                            .font(.caption)
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                    .lineLimit(1)
                }
            }
            .padding()
            .background {
                Rectangle()
                    .glassEffect(.clear, in: .rect)
                    .ignoresSafeArea()
            }
        }
    }
}
