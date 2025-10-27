// Tests/GetArticlesUseCaseTests.swift
import XCTest
import Domain
@testable import Application

final class MockRepo: ArticleRepository {
    var articles: [Article] = []
    var error: Error?
    func getArticles() async throws -> [Article] {
        if let e = error { throw e }
        return articles
    }
    func refreshArticles() async throws -> [Article] { try await getArticles() }
    func getArticleDetail(id: String) async throws -> Article {
        return articles.first { $0.id == id }!
    }
}

final class GetArticlesUseCaseTests: XCTestCase {
    func test_execute_returnsArticles() async throws {
        let repo = MockRepo()
        repo.articles = [Article(id: "1", title: "A", body: "B")]
        let uc = GetArticlesUseCaseImpl(repo: repo)
        let list = try await uc.execute()
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.first?.title, "A")
    }
}
