// Data/DataSources/ArticleLocalDataSource.swift
import Foundation

protocol ArticleLocalDataSource {
    func readArticles() async throws -> [ArticleDTO]
    func writeArticles(_ list: [ArticleDTO]) async throws
    func readArticle(id: String) async throws -> ArticleDTO?
    func writeArticle(_ item: ArticleDTO) async throws
}
