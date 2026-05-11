//
//  ItunesServiceProtocol.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 09/05/26.
//

import Foundation

@Observable
final class SongsViewModel {
    
    var songs: [ITunesMedia] = []
    var isLoading = false
    var error: Error?
    
    //MARK: - Private Variables
    
    private let itunesService: ItunesServiceProtocol

    //MARK: - Init
    
    init(itunesService: ItunesServiceProtocol = ItunesService()) {
        self.itunesService = itunesService
    }
    
    //MARK: - Functions
    
    func search(query: String) async {
        guard !query.isEmpty else {
            songs.removeAll()
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await itunesService.fetchSongs(query: query)
            songs = response.results
        } catch {
            if Task.isCancelled { return }
            self.error = error
        }
    }
}



