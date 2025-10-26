// Application/UseCases/GetArticlesUseCase.swift
import Foundation
//import Domain

public protocol GetArticlesUseCase {
    func execute() async throws -> [Article]       // offline-first
    func refresh() async throws -> [Article]
}

public final class GetArticlesUseCaseImpl: GetArticlesUseCase {
    private let repo: ArticleRepository
    public init(repo: ArticleRepository) { self.repo = repo }

    public func execute() async throws -> [Article] {
        try await repo.getArticles()
    }

    public func refresh() async throws -> [Article] {
        try await repo.refreshArticles()
    }
}
