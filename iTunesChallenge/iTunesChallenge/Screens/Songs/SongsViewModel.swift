//
//  ItunesServiceProtocol.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 09/05/26.
//

import Foundation

@Observable
@MainActor
final class SongsViewModel {
    
    var songs: [PlayableMedia] = []
    private(set) var isLoading = false
    private(set) var error: Error?
    var searchText = ""
    var cachedSongs: [PlayableMedia] = []
    
    //MARK: - Private Variables
    
    private let itunesService: ItunesServiceProtocol

    //MARK: - Init
    
    init(itunesService: ItunesServiceProtocol = ItunesService()) {
        self.itunesService = itunesService
    }
    
    var viewState: SongsViewState {
        if isLoading {
            return .loading
        }
        if let error {
            return .error(error.localizedDescription)
        }
        if !songs.isEmpty || !cachedSongs.isEmpty {
            return .loaded
        }
        return .idle
    }

    func searchDebounced() async {
        try? await Task.sleep(for: .milliseconds(500))
        guard !Task.isCancelled else { return }
        await search(query: searchText)
    }
    
    private func search(query: String) async {
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
}


//MARK: - View State

enum SongsViewState: Hashable {
    case idle
    case loading
    case loaded
    case error(String)
}
