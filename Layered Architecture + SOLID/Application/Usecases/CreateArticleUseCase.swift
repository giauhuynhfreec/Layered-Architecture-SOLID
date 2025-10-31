// Application/UseCases/CreateArticleUseCase.swift
import Foundation

public protocol CreateArticleUseCase {
    @discardableResult
    func execute(_ article: Article) async throws -> Article
}

public final class CreateArticleUseCaseImpl: CreateArticleUseCase {
    private let repo: ArticleRepository

    public init(repo: ArticleRepository) {
        self.repo = repo
    }

    public func execute(_ article: Article) async throws -> Article {
        try await repo.createArticle(article)
    }
}
