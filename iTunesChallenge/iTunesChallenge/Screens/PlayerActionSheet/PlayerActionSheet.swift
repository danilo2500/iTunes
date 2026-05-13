//
//  PlayerActionSheet.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 10/05/26.
//

import SwiftUI

struct PlayerActionSheet: View {
    
    @Binding var path: NavigationPath
    @Environment(PlayerViewModel.self) private var playerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Button("View album", systemImage: "music.note.square.stack") {
                    dismiss()
                    path.append(AppDestination.album(collectionID: playerViewModel.currentSong.collectionId))
                }
                .foregroundStyle(Color(.label))
                .listRowBackground(Color.clear)
            }
            .toolbar {
                ToolbarItem(placement: .title) {
                    Text(playerViewModel.currentSong.displayName)
                        .font(.headline)
                }
                ToolbarItem(placement: .subtitle) {
                    Text(playerViewModel.currentSong.artistName)
                        .font(.footnote)
                }
            }
        }
        .presentationDetents([.height(170)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    PlayerActionSheet(path: .constant(NavigationPath()))
        .environment(PlayerViewModel())
}
