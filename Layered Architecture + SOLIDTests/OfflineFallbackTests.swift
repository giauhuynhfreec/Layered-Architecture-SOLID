// Tests/OfflineFallbackTests.swift
import XCTest
@testable import Layered_Architecture___SOLID

final class FailingHTTP: HTTPClient {
    func getJSON(filename: String) async throws -> Data { throw HTTPClientError.notFound }
}

final class OfflineFallbackTests: XCTestCase {
    func test_refresh_fallback_to_cache_when_remote_fails() async throws {
        // Prepare local cache
        let local = ArticleLocalDataSourceImpl()
        try await local.writeArticles([ArticleDTO(id: "c1", title: "Cached", body: "OK")])

        // Remote fails
        let remote = ArticleRemoteDataSourceImpl(http: FailingHTTP())
        let repo = ArticleRepositoryImpl(remote: remote, local: local)

        let list = try await repo.refreshArticles()
        XCTAssertEqual(list.first?.title, "Cached")
    }
}
