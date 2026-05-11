//
//  ItunesServiceProtocol.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 09/05/26.
//


import Foundation

protocol ItunesServiceProtocol {
    func fetchSongs(query: String) async throws -> iTunesSearchResponse
    func fetchCollection(id: Int) async throws -> iTunesSearchResponse
}
