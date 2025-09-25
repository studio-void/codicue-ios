//
//  GenerateAuthHeader.swift
//  CodiCue
//
//  Created by 임정훈 on 9/25/25.
//

import Alamofire
import Foundation

func generateAuthHeader() -> HTTPHeaders {
    let jwtToken = UserDefaults.standard.string(forKey: "jwtToken") ?? ""
    print(jwtToken)

    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(jwtToken)"
    ]
    
    return headers
}
