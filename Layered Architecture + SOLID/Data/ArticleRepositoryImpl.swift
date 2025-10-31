// Data/ArticleRepositoryImpl.swift
import Foundation
//import Domain

public final class ArticleRepositoryImpl: ArticleRepository {
    private let remote: ArticleRemoteDataSource
    private let local: ArticleLocalDataSource

    init(remote: ArticleRemoteDataSource, local: ArticleLocalDataSource) {
        self.remote = remote
        self.local = local
    }

    public func getArticles() async throws -> [Article] {
        // Offline-first: trả cache trước nếu có, song song cập nhật
        let cached = try? await local.readArticles().map { $0.toEntity() }
        if let cached, !cached.isEmpty { return cached }
        // Không có cache → fetch remote
        let remoteList = try await remote.fetchArticles()
        try? await local.writeArticles(remoteList)
        return remoteList.map { $0.toEntity() }
    }

    public func refreshArticles() async throws -> [Article] {
        do {
            let remoteList = try await remote.fetchArticles()
            try? await local.writeArticles(remoteList)
            return remoteList.map { $0.toEntity() }
        } catch {
            // fallback giữ cache nếu có
            let cached = try? await local.readArticles().map { $0.toEntity() }
            if let cached, !cached.isEmpty { return cached }
            throw error
        }
    }

    public func getArticleDetail(id: String) async throws -> Article {
        // Thử local trước
        if let dto = try? await local.readArticle(id: id) {
            return dto.toEntity()
        }
        // Remote rồi ghi cache
        let dto = try await remote.fetchArticleDetail(id: id)
        try? await local.writeArticle(dto)
        return dto.toEntity()
    }

    public func createArticle(_ article: Article) async throws -> Article {
        let dto = article.toDTO()
        let created = try await remote.createArticle(dto)
        try? await local.writeArticle(created)
        return created.toEntity()
    }

    public func updateArticle(_ article: Article) async throws -> Article {
        let dto = article.toDTO()
        let updated = try await remote.updateArticle(dto)
        try? await local.writeArticle(updated)
        return updated.toEntity()
    }

    public func deleteArticle(id: String) async throws {
        try await remote.deleteArticle(id: id)
        try? await local.deleteArticle(id: id)
    }
}
