// Application/UseCases/GetArticleDetailUseCase.swift
import Foundation
//import Domain

public protocol GetArticleDetailUseCase {
    func execute(id: String) async throws -> Article
}

public final class GetArticleDetailUseCaseImpl: GetArticleDetailUseCase {
    private let repo: ArticleRepository
    public init(repo: ArticleRepository) { self.repo = repo }

    public func execute(id: String) async throws -> Article {
        try await repo.getArticleDetail(id: id)
    }
}
