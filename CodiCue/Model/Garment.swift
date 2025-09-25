//
//  Garment.swift
//  CodiCue
//
//  Created by 임정훈 on 9/25/25.
//

import SwiftUI

struct Garment: Identifiable, Codable {
    // API fields
    let id: Int
    let userId: Int
    let name: String
    let category: GarmentCategory
    let imageURL: String
    let recommendedBodyType: [BodyType]
    let advice: String?
    let tags: [String]
    let createdAt: Date
    let updatedAt: Date

    // CodingKeys to map imageUrl -> imageURL
    enum CodingKeys: String, CodingKey {
        case id, userId, name, category, recommendedBodyType, advice, tags, createdAt, updatedAt
        case imageURL = "imageUrl"
    }
}

extension Garment {
    static let mock: [Garment] = [
        .init(
            id: 1,
            userId: 1,
            name: "화이트 셔츠",
            category: .top,
            imageURL: "https://example.com/image.jpg",
            recommendedBodyType: [.rectangle, .hourglass],
            advice: "깔끔한 비즈니스 룩에 적합합니다.",
            tags: ["비즈니스", "깔끔", "화이트"],
            createdAt: ISO8601DateFormatter().date(from: "2024-01-01T00:00:00.000Z") ?? Date(),
            updatedAt: ISO8601DateFormatter().date(from: "2024-01-01T00:00:00.000Z") ?? Date()
        ),
        .init(
            id: 2,
            userId: 1,
            name: "아이보리 하프팬츠",
            category: .bottom,
            imageURL: "https://i.namu.wiki/i/plYksH3UeGGZLVgjTfbJ8rf1vN2HMIl9ztcpxtfpeQwCYR1CBh3SzbQ0RsgbZ65xiYR-fk7A3Dxy7cExs4rABQ.webp",
            recommendedBodyType: [.rectangle],
            advice: nil,
            tags: ["아이보리", "팬츠"],
            createdAt: Date(),
            updatedAt: Date()
        )
    ]
}
