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
    
    var body: some View {
        NavigationStack {
            List {
                Button("View album", systemImage: "music.note.square.stack") {
                    
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
    let song = ITunesSong.mock
    PlayerActionSheet(trackName: song.trackName, artistName: song.artistName)
}
