//
//  PlaybackControlsView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 14/05/26.
//

import SwiftUI

struct PlaybackControlsView: View {
    @Environment(PlayerViewModel.self) private var playerViewModel
    
    var body: some View {
        
        HStack {
            Spacer()
            HStack(spacing: 28) {
                Button("Previous Song", systemImage: "backward.end.alt.fill") {
                    playerViewModel.returnToPreviousSong()
                }
                .labelStyle(.iconOnly)
                .disabled(!playerViewModel.hasPrevious)
                Button(playerViewModel.isPlaying ? "Pause" : "Play", systemImage: playerViewModel.isPlaying ? "pause.fill" : "play.fill") {
                    playerViewModel.isPlaying.toggle()
                }
                .labelStyle(.iconOnly)
                .font(.title)
                .padding()
                .contentTransition(.symbolEffect(.replace))
                .glassEffect()
                Button("Next Song", systemImage: "forward.end.alt.fill") {
                    playerViewModel.goToNextSong()
                }
                .labelStyle(.iconOnly)
                .disabled(!playerViewModel.hasNext)
            }
            .tint(Color(.label))
            Spacer()
        }
    }
}
