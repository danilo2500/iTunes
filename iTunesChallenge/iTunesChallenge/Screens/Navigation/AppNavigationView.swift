import SwiftUI

enum AppDestination: Hashable {
    case player
    case album(collectionID: Int)
}

struct AppNavigationView: View {
    @State private var path = NavigationPath()
    @State private var showSplash = true
    @State private var playerViewModel = PlayerViewModel()

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
                            case .player:
                                PlayerView(path: $path)
                            case .album(let id):
                                AlbumView(collectionID: id, showHeader: true, isInspector: false, path: $path)
                            }
                        }
                        .safeAreaBar(edge: .bottom) {
                            MiniPlayerView()
                        }
                }
                .transition(.blurReplace)
                .environment(playerViewModel)
            }
        }
        .animation(.default, value: showSplash)
    }
}

#Preview {
    AppNavigationView()
}

