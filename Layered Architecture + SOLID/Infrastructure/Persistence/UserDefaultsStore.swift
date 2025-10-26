// Infrastructure/Persistence/UserDefaultsStore.swift
import Foundation

final class UserDefaultsStore {
    private let ud: UserDefaults
    init(_ ud: UserDefaults = .standard) { self.ud = ud }

    func set<T: Codable>(_ value: T, for key: String) throws {
        let data = try JSONEncoder().encode(value)
        ud.set(data, forKey: key)
    }

    func get<T: Codable>(_ type: T.Type, for key: String) throws -> T? {
        guard let data = ud.data(forKey: key) else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
