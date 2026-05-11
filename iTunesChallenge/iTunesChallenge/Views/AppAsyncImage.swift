import SwiftUI

struct AppAsyncImage<ImageView: View>: View {

    let url: URL
    @ViewBuilder let imageContent: (Image) -> ImageView

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                imageContent(image)
            case .failure:
                Image(systemName: "network.slash")
            @unknown default:
                Image(systemName: "photo")
            }
        }
    }
}
