#if canImport(FirebaseFirestore)
import Foundation
import FirebaseFirestore

// Remote data source sử dụng Firebase Firestore.
final class FirebaseArticleRemoteDataSource: ArticleRemoteDataSource {
    private let db: Firestore
    private let collectionPath: String

    init(db: Firestore = Firestore.firestore(), collectionPath: String = "articles") {
        self.db = db
        self.collectionPath = collectionPath

        let settings = db.settings
        if !(settings.cacheSettings is PersistentCacheSettings) {
            settings.cacheSettings = PersistentCacheSettings()
            db.settings = settings
        }
    }

    func fetchArticles() async throws -> [ArticleDTO] {
        let snapshot = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<QuerySnapshot, Error>) in
            collection().getDocuments(source: .default) { snapshot, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let snapshot {
                    continuation.resume(returning: snapshot)
                } else {
                    continuation.resume(throwing: FirebaseArticleRemoteError.noData)
                }
            }
        }
        return try snapshot.documents.map { try self.map(document: $0) }
    }

    func fetchArticleDetail(id: String) async throws -> ArticleDTO {
        let document = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<DocumentSnapshot, Error>) in
            collection().document(id).getDocument(source: .default) { snapshot, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let snapshot, snapshot.exists {
                    continuation.resume(returning: snapshot)
                } else {
                    continuation.resume(throwing: FirebaseArticleRemoteError.notFound)
                }
            }
        }
        return try map(document: document)
    }

    func createArticle(_ dto: ArticleDTO) async throws -> ArticleDTO {
        try await write(dto, merge: false)
    }

    func updateArticle(_ dto: ArticleDTO) async throws -> ArticleDTO {
        try await write(dto, merge: true)
    }

    func deleteArticle(id: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            collection().document(id).delete { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    private func write(_ dto: ArticleDTO, merge: Bool) async throws -> ArticleDTO {
        let data: [String: Any] = [
            "title": dto.title,
            "body": dto.body
        ]
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            collection().document(dto.id).setData(data, merge: merge) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
        return dto
    }

    private func collection() -> CollectionReference {
        db.collection(collectionPath)
    }

    private func map(document: DocumentSnapshot) throws -> ArticleDTO {
        guard let data = document.data() else {
            throw FirebaseArticleRemoteError.noData
        }
        guard let title = data["title"] as? String else {
            throw FirebaseArticleRemoteError.missingField("title")
        }
        guard let body = data["body"] as? String else {
            throw FirebaseArticleRemoteError.missingField("body")
        }
        return ArticleDTO(id: document.documentID, title: title, body: body)
    }
}

enum FirebaseArticleRemoteError: Error {
    case noData
    case missingField(String)
    case notFound
}
#else
import Foundation

/// Stub Firebase remote để project vẫn build khi chưa tích hợp SDK Firebase.
final class FirebaseArticleRemoteDataSource: ArticleRemoteDataSource {
    func fetchArticles() async throws -> [ArticleDTO] { throw FirebaseUnavailableError() }
    func fetchArticleDetail(id: String) async throws -> ArticleDTO { throw FirebaseUnavailableError() }
    func createArticle(_ dto: ArticleDTO) async throws -> ArticleDTO { throw FirebaseUnavailableError() }
    func updateArticle(_ dto: ArticleDTO) async throws -> ArticleDTO { throw FirebaseUnavailableError() }
    func deleteArticle(id: String) async throws { throw FirebaseUnavailableError() }
}

struct FirebaseUnavailableError: Error {}
#endif
