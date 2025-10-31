// Tests/GetArticlesUseCaseTests.swift
import XCTest
@testable import Layered_Architecture___SOLID

final class MockRepo: ArticleRepository {
    var articles: [Article] = []
    var error: Error?
    func getArticles() async throws -> [Article] {
        if let e = error { throw e }
        return articles
    }
    func refreshArticles() async throws -> [Article] { try await getArticles() }
    func getArticleDetail(id: String) async throws -> Article {
        if let match = articles.first(where: { $0.id == id }) {
            return match
        }
        throw MockRepoError.notFound
    }
    func createArticle(_ article: Article) async throws -> Article {
        articles.append(article)
        return article
    }
    func updateArticle(_ article: Article) async throws -> Article {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index] = article
        } else {
            articles.append(article)
        }
        return article
    }
    func deleteArticle(id: String) async throws {
        articles.removeAll { $0.id == id }
    }
}

enum MockRepoError: Error { case notFound }

final class GetArticlesUseCaseTests: XCTestCase {
    func test_execute_returnsArticles() async throws {
        let repo = MockRepo()
        repo.articles = [Article(id: "1", title: "A", body: "B")]
        let uc = GetArticlesUseCaseImpl(repo: repo)
        let list = try await uc.execute()
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.first?.title, "A")
    }

    func test_create_usecase_appendsArticle() async throws {
        let repo = MockRepo()
        let useCase = CreateArticleUseCaseImpl(repo: repo)
        let article = Article(id: "2", title: "New", body: "Body")
        let created = try await useCase.execute(article)
        XCTAssertEqual(created, article)
        XCTAssertEqual(repo.articles.count, 1)
    }

    func test_update_usecase_updatesArticle() async throws {
        let repo = MockRepo()
        repo.articles = [Article(id: "3", title: "Old", body: "Body")]
        let useCase = UpdateArticleUseCaseImpl(repo: repo)
        let updated = Article(id: "3", title: "Updated", body: "Body2")
        let result = try await useCase.execute(updated)
        XCTAssertEqual(result.title, "Updated")
        XCTAssertEqual(repo.articles.first?.body, "Body2")
    }

    func test_delete_usecase_removesArticle() async throws {
        let repo = MockRepo()
        repo.articles = [Article(id: "4", title: "Delete", body: "Me")]
        let useCase = DeleteArticleUseCaseImpl(repo: repo)
        try await useCase.execute(id: "4")
        XCTAssertTrue(repo.articles.isEmpty)
    }
}
