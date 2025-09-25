//
//  GenerateAuthHeader.swift
//  CodiCue
//
//  Created by 임정훈 on 9/25/25.
//

import Foundation
import Alamofire

func generateAuthHeader() -> HTTPHeaders {
    let jwtToken = UserDefaults.standard.string(forKey: "jwtToken") ?? ""

    if let data = jwtToken.data(using: .utf8) {
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(data)"
        ]
        return headers
    } else {
        return HTTPHeaders()
    }
}
