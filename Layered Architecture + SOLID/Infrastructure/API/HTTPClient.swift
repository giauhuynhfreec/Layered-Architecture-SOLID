// Infrastructure/API/HTTPClient.swift
import Foundation

enum HTTPClientError: Error { case notFound, invalidData }

protocol HTTPClient {
    func getJSON(filename: String) async throws -> Data
}

final class BundleHTTPClient: HTTPClient {
    // DEBUG: dùng *_debug.json, RELEASE: dùng *.json
    private let bundle: Bundle
    private let simulateNetworkFailure: Bool

    init(bundle: Bundle = .main, simulateNetworkFailure: Bool = false) {
        self.bundle = bundle
        self.simulateNetworkFailure = simulateNetworkFailure
    }

    func getJSON(filename: String) async throws -> Data {
        try await Task.sleep(nanoseconds: 200_000_000) // giả lập latency ~200ms

        if simulateNetworkFailure { throw HTTPClientError.notFound }

        #if DEBUG
        let name = filename + "_debug"
        #else
        let name = filename
        #endif

        guard let url = bundle.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw HTTPClientError.notFound
        }
        return data
    }
}
