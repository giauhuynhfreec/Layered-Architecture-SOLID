// Domain/Entities/Article.swift
import Foundation

public struct Article: Equatable, Identifiable, Codable {
    public let id: String
    public let title: String
    public let body: String
}
