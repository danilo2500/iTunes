import Foundation
@testable import iTunesChallenge

enum MockBehavior {
    case success
    case failure(Error, delay: UInt64 = 0)
}

final class MockItunesService: ItunesServiceProtocol {

    private let behavior: MockBehavior
    private(set) var fetchSongsCallCount = 0
    private(set) var fetchCollectionCallCount = 0

    init(behavior: MockBehavior = .success) {
        self.behavior = behavior
    }

    func fetchSongs(query: String) async throws -> iTunesSearchResponse {
        fetchSongsCallCount += 1
        switch behavior {
        case .success:
            return .mock
        case .failure(let error, let delay):
            try? await Task.sleep(for: .nanoseconds(delay))
            throw error
        }
    }

    func fetchCollection(id: Int) async throws -> iTunesSearchResponse {
        fetchCollectionCallCount += 1
        return .mock
    }
}

enum MockSearchError: Error, LocalizedError {
    case networkFailure

    var errorDescription: String? {
        switch self {
        case .networkFailure: return "Network failure"
        }
    }
}
