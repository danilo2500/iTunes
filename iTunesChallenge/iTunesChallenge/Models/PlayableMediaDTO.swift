//
//  PlayableMedia.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 11/05/26.
//


import Foundation

struct PlayableMedia: Hashable {
    let trackId: Int?
    let collectionId: Int
    let trackName: String?
    let artistName: String
    let artworkUrl100: URL
    let previewUrl: URL?
    let collectionName: String
    let trackNumber: Int?
    let trackCount: Int
    
    var displayName: String {
        trackName ?? collectionName
    }
    
    static let mock = PlayableMedia(
        trackId: 1228739609,
        collectionId: 617154241,
        trackName: "Get Lucky",
        artistName: "Daft Punk, Pharrell Williams & Nile Rodgers",
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/e8/43/5f/e8435ffa-b6b9-b171-40ab-4ff3959ab661/886443919266.jpg/100x100bb.jpg")!,
        previewUrl: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/d4/d3/1e/d4d31eb4-7405-b806-8346-3c52ad5b4cf4/mzaf_8095545455942962509.plus.aac.p.m4a")!,
        collectionName: "Random Access Memories",
        trackNumber: 8,
        trackCount: 13
    )

    static let mock2 = PlayableMedia(
        trackId: 1,
        collectionId: 1,
        trackName: "Song A",
        artistName: "Artist",
        artworkUrl100: URL(string: "https://example.com/1.jpg")!,
        previewUrl: URL(string: "https://example.com/1.m4a")!,
        collectionName: "Collection",
        trackNumber: 1,
        trackCount: 3
    )

    static let mock3 = PlayableMedia(
        trackId: 2,
        collectionId: 1,
        trackName: "Song B",
        artistName: "Artist",
        artworkUrl100: URL(string: "https://example.com/2.jpg")!,
        previewUrl: URL(string: "https://example.com/2.m4a")!,
        collectionName: "Collection",
        trackNumber: 2,
        trackCount: 3
    )
}

extension ITunesMedia {
    var asPlayableMedia: PlayableMedia {
        PlayableMedia(
            trackId: trackId,
            collectionId: collectionId,
            trackName: trackName,
            artistName: artistName,
            artworkUrl100: artworkUrl100,
            previewUrl: previewUrl,
            collectionName: collectionName,
            trackNumber: trackNumber,
            trackCount: trackCount
        )
    }
}

extension CachedSong {
    var asPlayableMedia: PlayableMedia {
        PlayableMedia(
            trackId: trackId,
            collectionId: collectionId,
            trackName: trackName,
            artistName: artistName,
            artworkUrl100: artworkUrl100,
            previewUrl: previewUrl,
            collectionName: collectionName,
            trackNumber: trackNumber,
            trackCount: trackCount
        )
    }
}
