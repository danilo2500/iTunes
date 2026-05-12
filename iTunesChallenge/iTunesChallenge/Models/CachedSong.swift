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
    
    var trackId: Int?
    var collectionId: Int
    var trackName: String?
    var artistName: String
    var previewUrl: URL?
    var collectionName: String
    var artworkUrl100: URL

    init(trackId: Int, collectionId: Int, trackName: String? = nil, artistName: String, previewUrl: URL? = nil, collectionName: String, artworkUrl100: URL) {
        self.trackId = trackId
        self.collectionId = collectionId
        self.trackName = trackName
        self.artistName = artistName
        self.previewUrl = previewUrl
        self.collectionName = collectionName
        self.artworkUrl100 = artworkUrl100
    }
}
