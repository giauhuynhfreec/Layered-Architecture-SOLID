// Data/DTO/ArticleDTO.swift
import Foundation

struct ArticleDTO: Codable, Equatable {
    let id: String
    let title: String
    let body: String
}
