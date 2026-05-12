import SwiftUI

enum AppDestination: Hashable {
    case player(PlayableMedia)
    case album(collectionID: Int)
}

struct AppNavigationView: View {
    @State private var path = NavigationPath()
    @State private var showSplash = true

    var body: some View {
        Group {
            if showSplash {
                SplashView()
                    .task {
                        try? await Task.sleep(for: .seconds(1))
                        showSplash = false
                    }
            } else {
                NavigationStack(path: $path) {
                    SongsView(path: $path)
                        .navigationDestination(for: AppDestination.self) { destination in
                            switch destination {
                            case .player(let item):
                                PlayerView(song: item, path: $path)
                            case .album(let id):
                                AlbumView(collectionID: id, showHeader: true, path: $path)
                            }
                        }
                }
                .transition(.blurReplace)
            }
        }
        .animation(.default, value: showSplash)
    }
}
