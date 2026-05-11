//
//  RecentSong.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 11/05/26.
//

import Foundation
import SwiftData

@Model
final class CachedSong {
    var trackId: Int
    var collectionId: Int
    var trackName: String?
    var artistName: String
    var previewUrl: URL?
    var collectionName: String
    var artworkUrl100: URL

    init(from media: ITunesMedia) {
        self.trackId = media.trackId ?? 0
        self.collectionId = media.collectionId
        self.trackName = media.trackName
        self.artistName = media.artistName
        self.previewUrl = media.previewUrl
        self.collectionName = media.collectionName
        self.artworkUrl100 = media.artworkUrl100
    }

    var asITunesMedia: ITunesMedia {
        ITunesMedia(
            wrapperType: .track,
            trackId: trackId == 0 ? nil : trackId,
            collectionId: collectionId,
            trackName: trackName,
            artistName: artistName,
            previewUrl: previewUrl,
            collectionName: collectionName,
            artworkUrl100: artworkUrl100
        )
    }
}
