// Application/UseCases/DeleteArticleUseCase.swift
import Foundation

public protocol DeleteArticleUseCase {
    func execute(id: String) async throws
}

public final class DeleteArticleUseCaseImpl: DeleteArticleUseCase {
    private let repo: ArticleRepository

    public init(repo: ArticleRepository) {
        self.repo = repo
    }

    public func execute(id: String) async throws {
        try await repo.deleteArticle(id: id)
    }
}
