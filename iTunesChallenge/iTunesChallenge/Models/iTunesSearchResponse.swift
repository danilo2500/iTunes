//
//  iTunesSearchResponse.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 09/05/26.
//

import Foundation

struct iTunesSearchResponse: Decodable {
    let resultCount: Int
    let results: [ITunesSong]
}

struct ITunesSong: Decodable, Identifiable {
    var id: Int {
        trackId
    }
    
    let trackId: Int
//    let artistId: Int
//    let collectionId: Int
    let trackName: String
    let artistName: String
//    let collectionName: String
    let artworkUrl100: URL
//    let trackViewUrl: String
//    let previewUrl: String
    
    static let mock = ITunesSong(
        trackId: 1228739609,
        trackName: "Dua Lipa",
        artistName: "New Rules",
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/c1/54/2d/c1542d45-c6c2-12ca-7308-6eacd762c562/190295807870.jpg/100x100bb.jpg")!
    )
}
