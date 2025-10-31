// Application/UseCases/UpdateArticleUseCase.swift
import Foundation

public protocol UpdateArticleUseCase {
    @discardableResult
    func execute(_ article: Article) async throws -> Article
}

public final class UpdateArticleUseCaseImpl: UpdateArticleUseCase {
    private let repo: ArticleRepository

    public init(repo: ArticleRepository) {
        self.repo = repo
    }

    public func execute(_ article: Article) async throws -> Article {
        try await repo.updateArticle(article)
    }
}
