//
//  iTunesSearchResponse.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 09/05/26.
//

import Foundation

struct iTunesSearchResponse: Decodable {
    let resultCount: Int
    let results: [ITunesMedia]

    static let mock = iTunesSearchResponse(
        resultCount: 1,
        results: [.mock]
    )
}

struct ITunesMedia: Decodable, Hashable {
    
    var displayName: String {
        trackName ?? collectionName
    }
    
    let wrapperType: WrapperType?
    let trackId: Int?
    let collectionId: Int
    let trackName: String?
    let artistName: String
    let previewUrl: URL?
    let collectionName: String
    let artworkUrl100: URL
    let trackNumber: Int?
    let trackCount: Int

    static let mock = ITunesMedia(
        wrapperType: .track,
        trackId: 1228739609,
        collectionId: 617154241,
        trackName: "Get Lucky",
        artistName: "Daft Punk, Pharrell Williams & Nile Rodgers",
        previewUrl: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/d4/d3/1e/d4d31eb4-7405-b806-8346-3c52ad5b4cf4/mzaf_8095545455942962509.plus.aac.p.m4a")!,
        collectionName: "Random Access Memories",
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/e8/43/5f/e8435ffa-b6b9-b171-40ab-4ff3959ab661/886443919266.jpg/100x100bb.jpg")!,
        trackNumber: 8,
        trackCount: 13
    )
}

enum WrapperType: String, Decodable {
    case collection
    case track
    case artist
}
