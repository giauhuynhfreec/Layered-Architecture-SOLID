// Infrastructure/DataSources Implementations
import Foundation

final class ArticleLocalDataSourceImpl: ArticleLocalDataSource {
    private let disk = DiskCache()
    private let ud = UserDefaultsStore()

    func readArticles() async throws -> [ArticleDTO] {
        if let list: [ArticleDTO] = try ud.get([ArticleDTO].self, for: "articles") {
            return list
        }
        // fallback file
        if let data = try? disk.read(for: "articles.json"),
           let list = try? JSONDecoder().decode([ArticleDTO].self, from: data) {
            return list
        }
        return []
    }

    func writeArticles(_ list: [ArticleDTO]) async throws {
        try ud.set(list, for: "articles")
        let data = try JSONEncoder().encode(list)
        try disk.write(data, for: "articles.json")
    }

    func readArticle(id: String) async throws -> ArticleDTO? {
        let list = try await readArticles()
        return list.first { $0.id == id }
    }

    func writeArticle(_ item: ArticleDTO) async throws {
        var list = try await readArticles()
        if let idx = list.firstIndex(where: { $0.id == item.id }) {
            list[idx] = item
        } else {
            list.append(item)
        }
        try await writeArticles(list)
    }

    func deleteArticle(id: String) async throws {
        var list = try await readArticles()
        list.removeAll { $0.id == id }
        try await writeArticles(list)
    }
}
