// Tests/MappingTests.swift
import XCTest
@testable import Layered_Architecture___SOLID

final class MappingTests: XCTestCase {
    func test_dto_to_entity_and_back() {
        let dto = ArticleDTO(id: "x", title: "t", body: "b")
        let entity = dto.toEntity()
        XCTAssertEqual(entity.id, "x")
        XCTAssertEqual(entity.title, "t")
        XCTAssertEqual(entity.body, "b")
        let back = entity.toDTO()
        XCTAssertEqual(back, dto)
    }
}
