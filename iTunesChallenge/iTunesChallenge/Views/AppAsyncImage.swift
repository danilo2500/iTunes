import SwiftUI

struct AppAsyncImage<ImageView: View>: View {

    let url: URL
    @ViewBuilder let imageContent: (Image) -> ImageView

    @State private var image: UIImage?
    @State private var failed = false

    var body: some View {
        Group {
            if let image {
                imageContent(Image(uiImage: image))
            } else if failed {
                Image(systemName: "network.slash")
            } else {
                ProgressView()
            }
        }
        .task {
            await loadImage()
        }
    }

    private func loadImage() async {
        guard !Task.isCancelled else { return }

        if let cached = await ImageCacheManager.shared.cachedImage(for: url) {
            image = cached
            return
        }

        do {
            let uiImage = try await ImageCacheManager.shared.fetchImage(from: url)
            guard !Task.isCancelled else { return }
            image = uiImage
        } catch {
            guard !Task.isCancelled else { return }
            failed = true
        }
    }
}
