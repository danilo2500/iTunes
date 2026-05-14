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
    let collectionId: Int
    
    @Binding var path: NavigationPath
    @State private var showPopover = false
    
    var body: some View {
        HStack(spacing: 16) {
            AppAsyncImage(url: artworkUrl) { image in
                image
                    .resizable()
                    .clipShape(.rect(cornerRadius: 8))
            }
            .frame(width: 52, height: 52)
            .accessibilityHidden(true)
            
            VStack(alignment: .leading) {
                Text(trackName)
                    .font(.callout)
                Text(artistName)
                    .font(.caption)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            .lineLimit(1)
            Spacer()
            Button("More actions for \(trackName)", systemImage: "ellipsis") {
                showPopover = true
            }
            .labelStyle(.iconOnly)
            .frame(minWidth: 44, minHeight: 44)
            .popover(isPresented: $showPopover) {
                Button("View Album") {
                    showPopover = false
                    path.append(AppDestination.album(collectionID: collectionId))
                }
                .padding()
                .presentationCompactAdaptation(.popover)
            }
        }
        .tint(Color(.secondaryLabel))
        .accessibilityAction(named: "View Album") {
            path.append(AppDestination.album(collectionID: collectionId))
        }
    }
}

#Preview {
    let song = ITunesMedia.mock
    SongListRow(trackName: song.displayName, artistName: song.artistName, artworkUrl: song.artworkUrl100, collectionId: song.collectionId, path: .constant(NavigationPath()))
}
