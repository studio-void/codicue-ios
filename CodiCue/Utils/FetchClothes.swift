//
//  FetchClothes.swift
//  CodiCue
//
//  Created by 임정훈 on 9/25/25.
//

import SwiftUI
import Foundation
import SwiftyJSON

func fetchClothes() async -> [Garment] {
    let header = generateAuthHeader()
    let (isSuccess, jsonOpt) = await sendGetRequest(endpoint: "user/items", headers: generateAuthHeader())
    guard isSuccess, let json = jsonOpt else {
        return []
    }

    // Expecting an array of stylist objects
    let array = json.arrayValue

    var parsed: [Garment] = []
    let iso = ISO8601DateFormatter()

    for item in array {
        // Primitive fields
        let id = item["id"].intValue
        let userId = item["userId"].intValue
        let name = item["name"].stringValue

        // Enum mappings
        let categoryRaw = item["category"].stringValue
        let category = GarmentCategory(rawValue: categoryRaw) ?? .top

        // Simple strings / optionals
        let imageURL = item["imageUrl"].stringValue
        let advice = item["advice"].string

        // Arrays
        let tags = item["tags"].arrayObject as? [String] ?? []
        let bodyTypeStrings = item["recommendedBodyType"].arrayObject as? [String] ?? []
        let recommendedBodyType = bodyTypeStrings.compactMap { BodyType(rawValue: $0) }

        // Dates: support milliseconds since epoch or ISO8601 strings
        var createdAt: Date = Date()
        var updatedAt: Date = Date()
        if let createdMillis = item["createdAt"].double {
            createdAt = Date(timeIntervalSince1970: createdMillis / 1000.0)
        } else if let createdStr = item["createdAt"].string, let date = iso.date(from: createdStr) {
            createdAt = date
        }
        if let updatedMillis = item["updatedAt"].double {
            updatedAt = Date(timeIntervalSince1970: updatedMillis / 1000.0)
        } else if let updatedStr = item["updatedAt"].string, let date = iso.date(from: updatedStr) {
            updatedAt = date
        }

        let garment = Garment(
            id: id,
            userId: userId,
            name: name,
            category: category,
            imageURL: imageURL,
            recommendedBodyType: recommendedBodyType,
            advice: advice,
            tags: tags,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
        parsed.append(garment)
    }

    return parsed
}
