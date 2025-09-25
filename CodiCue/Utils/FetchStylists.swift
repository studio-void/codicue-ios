//
//  FetchStylists.swift
//  CodiCue
//
//  Created by 임정훈 on 9/25/25.
//

import SwiftUI
import Foundation
import SwiftyJSON

func fetchStylists() async -> [StylistInfo] {
    let (isSuccess, jsonOpt) = await sendGetRequest(endpoint: "stylists")
    guard isSuccess, let json = jsonOpt else {
        return []
    }

    // Expecting an array of stylist objects
    let array = json.arrayValue

    var parsed: [StylistInfo] = []
    let iso = ISO8601DateFormatter()

    for item in array {
        // Extract typed values using SwiftyJSON accessors
        let id = item["id"].stringValue
        let name = item["name"].stringValue
        let rating = item["rating"].doubleValue
        let reviewCount = item["reviewCount"].intValue
        let isVerified = item["isVerified"].boolValue
        let introduction = item["introduction"].stringValue
        let career = item["career"].arrayObject as? [String] ?? []
        let profileImageUrl = item["profileImageUrl"].stringValue
        let specialtyStyles = item["specialtyStyles"].arrayObject as? [String] ?? []

        // Parse dates from either timestamp or ISO8601 string
        var createdAt: Date = Date()
        var updatedAt: Date = Date()
        if let createdMillis = item["createdAt"].double {  // milliseconds since epoch
            createdAt = Date(timeIntervalSince1970: createdMillis / 1000.0)
        } else if let createdStr = item["createdAt"].string, let date = iso.date(from: createdStr) {
            createdAt = date
        }
        if let updatedMillis = item["updatedAt"].double {
            updatedAt = Date(timeIntervalSince1970: updatedMillis / 1000.0)
        } else if let updatedStr = item["updatedAt"].string, let date = iso.date(from: updatedStr) {
            updatedAt = date
        }

        let stylist = StylistInfo(
            id: Int(id) ?? 0,
            name: name,
            rating: rating,
            reviewCount: reviewCount,
            isVerified: isVerified,
            introduction: introduction,
            career: career,
            profileImageUrl: profileImageUrl,
            specialtyStyles: specialtyStyles,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
        parsed.append(stylist)
    }

    return parsed
}
