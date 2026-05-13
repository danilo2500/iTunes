import XCTest
@testable import iTunesChallenge
import SwiftData

@MainActor
final class SongsViewModelTests: XCTestCase {

    func test_initialState_viewState_isIdle() async {
        let sut = makeSUT()
        XCTAssertEqual(sut.viewState, .idle)
    }

    func test_viewState_whenSongsLoaded_isLoaded() async {
        let sut = makeSUT()
        sut.songs = [.mock]

        XCTAssertEqual(sut.viewState, .loaded)
    }

    func test_viewState_whenCachedSongsLoaded_isLoaded() async {
        let sut = makeSUT()
        sut.cachedSongs = [.mock]

        XCTAssertEqual(sut.viewState, .loaded)
    }

    func test_searchDebounced_success_viewState_isLoaded() async {
        let mockService = MockItunesService()
        let sut = makeSUT(service: mockService)
        sut.searchText = "Daft Punk"

        await sut.searchDebounced()

        XCTAssertEqual(sut.viewState, .loaded)
        XCTAssertEqual(sut.songs.count, 1)
        XCTAssertEqual(mockService.fetchSongsCallCount, 1)
    }

    func test_searchDebounced_failure_viewState_isError() async {
        let mockService = MockItunesService(behavior: .failure(MockSearchError.networkFailure))
        let sut = makeSUT(service: mockService)
        sut.searchText = "Daft Punk"

        await sut.searchDebounced()

        XCTAssertEqual(sut.viewState, .error("Network failure"))
        XCTAssertTrue(sut.songs.isEmpty)
        XCTAssertEqual(mockService.fetchSongsCallCount, 1)
    }

    func test_searchDebounced_emptyQuery_viewState_isIdle() async {
        let mockService = MockItunesService()
        let sut = makeSUT(service: mockService)
        sut.songs = [.mock]
        sut.searchText = ""

        await sut.searchDebounced()

        XCTAssertEqual(sut.viewState, .idle)
        XCTAssertTrue(sut.songs.isEmpty)
        XCTAssertEqual(mockService.fetchSongsCallCount, 0)
    }

    func test_searchDebounced_loading_viewState_isLoading() async {
        let mockService = MockItunesService(
            behavior: .failure(MockSearchError.networkFailure, delay: 5_000_000_000)
        )
        let sut = makeSUT(service: mockService)
        sut.searchText = "Daft Punk"

        let task = Task { await sut.searchDebounced() }
        try? await Task.sleep(for: .milliseconds(600))
        XCTAssertEqual(sut.viewState, .loading)
        XCTAssertEqual(mockService.fetchSongsCallCount, 1)

        task.cancel()
        _ = await task.value
    }

    func test_searchDebounced_cancellation_serviceNotCalled() async {
        let mockService = MockItunesService()
        let sut = makeSUT(service: mockService)
        sut.searchText = "Daft Punk"

        let task = Task { await sut.searchDebounced() }
        try? await Task.sleep(for: .milliseconds(50))
        task.cancel()
        await task.value

        XCTAssertEqual(mockService.fetchSongsCallCount, 0)
    }

    // MARK: - Helpers

    private func makeSUT(
        service: MockItunesService = MockItunesService(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SongsViewModel {
        let sut = SongsViewModel(itunesService: service)
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Instance should be deallocated", file: file, line: line)
        }
        return sut
    }
}
