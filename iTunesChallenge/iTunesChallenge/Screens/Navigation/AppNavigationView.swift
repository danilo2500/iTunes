import SwiftUI

struct AppNavigationView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            SongsView(path: $path)
            .navigationDestination(for: ITunesMedia.self) { song in
                PlayerView(song: song, path: $path)
            }
            .navigationDestination(for: Int.self) { id in
                AlbumView(collectionID: id, path: $path)
            }
        }
    }
}
