//
//  StylistInfo.swift
//  CodiCue
//
//  Created by 임정훈 on 9/22/25.
//

import Foundation

struct StylistInfo: Hashable, Identifiable {
    var id: Int
    var name: String
    var rating: Double
    var reviewCount: Int
    var isVerified: Bool
    var introduction: String
    var career: [String]
    var profileImageUrl: String
    var specialtyStyles: [String]
    var createdAt: Date
    var updatedAt: Date
}
