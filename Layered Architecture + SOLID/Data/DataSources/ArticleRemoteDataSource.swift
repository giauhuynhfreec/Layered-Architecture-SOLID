// Data/DataSources/ArticleRemoteDataSource.swift
import Foundation

protocol ArticleRemoteDataSource {
    func fetchArticles() async throws -> [ArticleDTO]
    func fetchArticleDetail(id: String) async throws -> ArticleDTO
}
