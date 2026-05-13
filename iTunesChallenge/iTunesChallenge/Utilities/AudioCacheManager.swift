import Foundation

actor AudioCacheManager {

    static let shared = AudioCacheManager()

    private let cacheDirectory: URL
    private var activeDownloads: [String: Task<URL, Error>] = [:]
    private let maxCacheSize: UInt64 = 500 * 1024 * 1024

    private init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = caches.appendingPathComponent("com.itunes.audiocache", isDirectory: true)
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    nonisolated func localURL(for remoteURL: URL) -> URL? {
        let destination = cacheDirectory.appendingPathComponent(filename(from: remoteURL))
        guard FileManager.default.fileExists(atPath: destination.path) else { return nil }
        return destination
    }

    func cacheAudio(from remoteURL: URL) async throws -> URL {
        let key = filename(from: remoteURL)
        let destination = cacheDirectory.appendingPathComponent(key)

        if FileManager.default.fileExists(atPath: destination.path) {
            return destination
        }

        if let existing = activeDownloads[key] {
            return try await existing.value
        }

        let task = Task<URL, Error> {
            defer { activeDownloads[key] = nil }
            let (data, _) = try await URLSession.shared.data(from: remoteURL)
            try data.write(to: destination)
            evictIfNeeded()
            return destination
        }
        activeDownloads[key] = task
        return try await task.value
    }

    private func evictIfNeeded() {
        guard let enumerator = FileManager.default.enumerator(
            at: cacheDirectory,
            includingPropertiesForKeys: [.fileSizeKey, .contentModificationDateKey],
            options: .skipsHiddenFiles
        ) else { return }

        var files: [(url: URL, size: UInt64, date: Date)] = []
        var totalSize: UInt64 = 0

        for case let fileURL as URL in enumerator {
            guard let attrs = try? fileURL.resourceValues(forKeys: [.fileSizeKey, .contentModificationDateKey]),
                  let size = attrs.fileSize,
                  let date = attrs.contentModificationDate
            else { continue }
            let uSize = UInt64(size)
            files.append((fileURL, uSize, date))
            totalSize += uSize
        }

        guard totalSize > maxCacheSize else { return }

        files.sort { $0.date < $1.date }

        for file in files {
            try? FileManager.default.removeItem(at: file.url)
            totalSize -= file.size
            if totalSize <= maxCacheSize { break }
        }
    }

    nonisolated private func filename(from url: URL) -> String {
        return url.lastPathComponent
    }
}
