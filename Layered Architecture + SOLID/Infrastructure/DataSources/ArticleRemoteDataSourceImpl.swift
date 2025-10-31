// Infrastructure/DataSources Implementations
import Foundation

final class ArticleRemoteDataSourceImpl: ArticleRemoteDataSource {
    private let http: HTTPClient
    init(http: HTTPClient) { self.http = http }

    func fetchArticles() async throws -> [ArticleDTO] {
        let data = try await http.getJSON(filename: "articles")
        return try JSONDecoder().decode([ArticleDTO].self, from: data)
    }

    func fetchArticleDetail(id: String) async throws -> ArticleDTO {
        let data = try await http.getJSON(filename: "article_detail")
        return try JSONDecoder().decode(ArticleDTO.self, from: data)
    }

    func createArticle(_ dto: ArticleDTO) async throws -> ArticleDTO {
        // Stub tạo article khi chạy mà không có Firebase.
        return dto
    }

    func updateArticle(_ dto: ArticleDTO) async throws -> ArticleDTO {
        // Stub cập nhật article khi chạy mà không có Firebase.
        return dto
    }

    func deleteArticle(id: String) async throws {
        // Stub xóa article khi chạy mà không có Firebase.
    }
}
