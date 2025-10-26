// Domain/Repositories/ArticleRepository.swift
import Foundation

public protocol ArticleRepository {
    func getArticles() async throws -> [Article]        // cache-first then refresh
    func refreshArticles() async throws -> [Article]    // force remote, update cache
    func getArticleDetail(id: String) async throws -> Article
}
