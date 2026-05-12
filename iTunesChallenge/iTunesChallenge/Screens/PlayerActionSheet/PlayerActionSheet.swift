//
//  PlayerActionSheet.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 10/05/26.
//

import SwiftUI

struct PlayerActionSheet: View {
    
    let trackName: String
    let artistName: String
    let collectionId: Int
    
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Button("View album", systemImage: "music.note.square.stack") {
                    dismiss()
                    path.append(AppDestination.album(collectionID: collectionId))
                }
                .foregroundStyle(Color(.label))
                .listRowBackground(Color.clear)
            }
            .toolbar {
                ToolbarItem(placement: .title) {
                    Text(trackName)
                        .font(.headline)
                }
                ToolbarItem(placement: .subtitle) {
                    Text(artistName)
                        .font(.footnote)
                }
            }
        }
        .presentationDetents([.height(170)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    PlayerActionSheet(trackName: "Song", artistName: "Artist", collectionId: 123, path: .constant(NavigationPath()))
}
