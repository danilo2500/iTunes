//
//  ItunesService.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 09/05/26.
//


import Foundation

final class ItunesService: ItunesServiceProtocol {
    private let restService = RESTService<ItunesAPI>()
    
    func fetchSongs(query: String) async throws -> iTunesSearchResponse {
        return try await restService.request(.getSongs(query: query))
    }
}
