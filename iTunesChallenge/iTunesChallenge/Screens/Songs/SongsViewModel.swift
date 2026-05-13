//
//  ItunesServiceProtocol.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 09/05/26.
//

import Foundation

@Observable
final class SongsViewModel {
    
    var songs: [PlayableMedia] = []
    var isLoading = false
    var error: Error?
    var searchText = ""
    var cachedSongs: [CachedSong] = []
    
    //MARK: - Private Variables
    
    private let itunesService: ItunesServiceProtocol

    //MARK: - Init
    
    init(itunesService: ItunesServiceProtocol = ItunesService()) {
        self.itunesService = itunesService
    }
    
    //MARK: - View State
    
    enum ViewState: Hashable {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    var viewState: ViewState {
        if isLoading { return .loading }
        if let error { return .error(error.localizedDescription) }
        if !songs.isEmpty || !cachedSongs.isEmpty { return .loaded }
        return .idle
    }
    
    //MARK: - Functions
    
    func updateCachedSongs(_ songs: [CachedSong]) {
        cachedSongs = songs
    }
    
    func search(query: String) async {
        guard !query.isEmpty else {
            songs.removeAll()
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await itunesService.fetchSongs(query: query)
            songs = response.results.map(\.asPlayableMedia)
        } catch {
            if Task.isCancelled { return }
            self.error = error
        }
    }
    
    func searchDebounced() async {
        try? await Task.sleep(for: .milliseconds(500))
        guard !Task.isCancelled else { return }
        await search(query: searchText)
    }
}
