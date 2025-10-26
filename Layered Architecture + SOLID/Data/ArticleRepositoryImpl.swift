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
}
