//
//  AlbumViewModel.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 13/05/26.
//



import Foundation

@Observable
final class AlbumViewModel {
    
    var songs: [PlayableMedia] = []
    var album: PlayableMedia? {
        songs.first
    }
    var isLoading = false
    var error: Error?
    
    //MARK: - Private Variables
    
    private let itunesService: ItunesServiceProtocol
    
    //MARK: - Init
    
    init(itunesService: ItunesServiceProtocol = ItunesService()) {
        self.itunesService = itunesService
    }
    
    //MARK: - Functions
    
    func fetchSongs(collectionID: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await itunesService.fetchCollection(id: collectionID)
            songs = response.results
                .filter({ $0.wrapperType == .track })
                .map(\.asPlayableMedia)
        } catch {
            print(error)
            self.error = error
        }
    }
}



