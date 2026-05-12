import UIKit

actor ImageCacheManager {

    static let shared = ImageCacheManager()

    private let memoryCache: NSCache<NSURL, UIImage>
    private let session: URLSession

    private init() {
        memoryCache = {
            let cache = NSCache<NSURL, UIImage>()
            cache.countLimit = 100
            cache.totalCostLimit = 50 * 1024 * 1024
            return cache
        }()

        let cachesURL = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("com.itunes.imagecache", isDirectory: true)

        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(
            memoryCapacity: 4 * 1024 * 1024,
            diskCapacity: 100 * 1024 * 1024,
            directory: cachesURL
        )
        config.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: config)
    }

    func cachedImage(for url: URL) -> UIImage? {
        memoryCache.object(forKey: url as NSURL)
    }

    func fetchImage(from url: URL) async throws -> UIImage {
        if let cached = memoryCache.object(forKey: url as NSURL) {
            return cached
        }

        let (data, _) = try await session.data(from: url)

        guard let image = UIImage(data: data) else {
            throw ImageCacheError.invalidImageData
        }

        memoryCache.setObject(image, forKey: url as NSURL, cost: data.count)
        return image
    }
}

enum ImageCacheError: Error {
    case invalidImageData
}
