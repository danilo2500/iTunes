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
            AppAsyncImage(url: artworkUrl) { image in
                image
                    .resizable()
                    .clipShape(.rect(cornerRadius: 8))
            }
            .frame(width: 52, height: 52)
            
            VStack(alignment: .leading) {
                Text(trackName)
                    .font(.callout)
                Text(artistName)
                    .font(.caption)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            .lineLimit(1)
            Spacer()
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
            
        }
        .tint(Color(.secondaryLabel))
    }
}

#Preview {
    let song = ITunesMedia.mock
    SongListRow(trackName: song.displayName + "1231231231dkls k askdkas d lkas dk", artistName: song.artistName, artworkUrl: song.artworkUrl100)
}
