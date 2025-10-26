// Infrastructure/Persistence/DiskCache.swift
import Foundation

struct DiskCache {
    private let fm = FileManager.default
    private let baseURL: URL

    init(folder: String = "Cache") {
        let dir = fm.urls(for: .cachesDirectory, in: .userDomainMask).first!
        baseURL = dir.appendingPathComponent(folder, isDirectory: true)
        try? fm.createDirectory(at: baseURL, withIntermediateDirectories: true)
    }

    func write(_ data: Data, for key: String) throws {
        let url = baseURL.appendingPathComponent(key)
        try data.write(to: url, options: .atomic)
    }

    func read(for key: String) throws -> Data {
        let url = baseURL.appendingPathComponent(key)
        return try Data(contentsOf: url)
    }
}
