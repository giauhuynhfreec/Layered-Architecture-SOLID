// Data/DataSources/ArticleRemoteDataSource.swift
import Foundation

protocol ArticleRemoteDataSource {
    func fetchArticles() async throws -> [ArticleDTO]
    func fetchArticleDetail(id: String) async throws -> ArticleDTO
    func createArticle(_ dto: ArticleDTO) async throws -> ArticleDTO
    func updateArticle(_ dto: ArticleDTO) async throws -> ArticleDTO
    func deleteArticle(id: String) async throws
}
