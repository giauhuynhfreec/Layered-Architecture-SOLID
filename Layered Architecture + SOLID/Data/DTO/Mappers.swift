// Data/DTO/Mappers.swift
import Foundation
//import Domain

extension ArticleDTO {
    func toEntity() -> Article {
        Article(id: id, title: title, body: body)
    }
}

extension Article {
    func toDTO() -> ArticleDTO {
        ArticleDTO(id: id, title: title, body: body)
    }
}
