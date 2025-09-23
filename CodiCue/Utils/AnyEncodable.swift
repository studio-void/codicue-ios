//
//  AnyEncodable.swift
//  CodiCue
//
//  Created by 임정훈 on 9/23/25.
//

struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void

    init<T: Encodable>(_ value: T) {
        _encode = value.encode
    }

    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
