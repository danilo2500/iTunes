import SwiftUI

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
                        .navigationDestination(for: ITunesMedia.self) { song in
                            PlayerView(song: song, path: $path)
                        }
                        .navigationDestination(for: Int.self) { id in
                            AlbumView(collectionID: id, path: $path)
                        }
                }
                .transition(.blurReplace)
            }
        }
        .animation(.default, value: showSplash)
    }
}
