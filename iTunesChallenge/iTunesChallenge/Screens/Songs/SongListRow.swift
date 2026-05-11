//
//  SongListRow.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 10/05/26.
//


import SwiftUI

struct SongListRow: View {
    
    let trackName: String
    let artistName: String
    let artworkUrl: URL
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: artworkUrl)
                .frame(width: 52, height: 52)
                .clipShape(.rect(cornerRadius: 8))
            LabeledContent {
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                }
                .popover(isPresented: .constant(false)) {
                    NavigationLink("View Album") {
                        EmptyView()
                    }
                    .padding()
                    .presentationCompactAdaptation(.popover)
                }
            } label: {
                Text(trackName)
                    .font(.callout)
                Text(artistName)
                    .font(.caption)
            }
        }
        .tint(Color(.secondaryLabel))
    }
}

#Preview {
    let song = ITunesMedia.mock
    SongListRow(trackName: song.displayName, artistName: song.artistName, artworkUrl: song.artworkUrl100)
}
