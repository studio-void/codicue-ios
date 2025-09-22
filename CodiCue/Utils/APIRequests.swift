//
//  APIRequests.swift
//  CodiCue
//
//  Created by 임정훈 on 9/22/25.
//

import SwiftUI
import VoidUtilities
import Alamofire
import SwiftyJSON

func sendPostRequest<T: Encodable>(endpoint: String,
                                   parameters: T,
                                   headers: HTTPHeaders? = nil) async -> (Bool, JSON?) {
    let url = URL(string: "\(Constants.baseURL)/\(endpoint)")!

    let defaultHeaders: HTTPHeaders = ["Content-Type": "application/json"]
    let updatedHeaders = headers != nil ? HTTPHeaders(defaultHeaders.dictionary.merging(headers!.dictionary) { $1 }) : defaultHeaders
    
    print("URL: \(url)")
    print("Parameters: \(parameters)")
    print("Headers: \(updatedHeaders)")
    
    let response = await AF.request(url,
                                   method: .post,
                                   parameters: parameters,
                                   encoder: JSONParameterEncoder.default,
                                   headers: updatedHeaders)
                                   .serializingData().response

    let isSuccess = (response.response?.statusCode ?? 0) < 400
    let json = JSON(response.data ?? Data())
    
    print("Response Status Code: \(response.response?.statusCode ?? 0)")
    print("Response Data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No Data")")
    return (isSuccess, json)
}

func sendGetRequest(endpoint: String,
                    headers: HTTPHeaders? = nil) async -> (Bool, JSON?) {
    let url = URL(string: "\(Constants.baseURL)/\(endpoint)")!
    
    let defaultHeaders: HTTPHeaders = [:]
    let updatedHeaders = headers != nil ? HTTPHeaders(defaultHeaders.dictionary.merging(headers!.dictionary) { $1 }) : defaultHeaders
    
    print("URL: \(url)")
    print("Headers: \(updatedHeaders)")

    let response = await AF.request(url,
                                    method: .get,
                                    headers: updatedHeaders)
                                    .serializingData().response
    
    let statusCode = response.response?.statusCode ?? 0
    let isSuccess = statusCode < 400
    let json = JSON(response.data ?? Data())
    
    print("Response Status Code: \(statusCode)")
    print("Response Data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No Data")")
    
    return (isSuccess, json)
}


func sendDeleteRequest(endpoint: String,
                      headers: HTTPHeaders? = nil) async -> (Bool, JSON?) {
    let url = URL(string: "\(Constants.baseURL)/\(endpoint)")!

    let defaultHeaders: HTTPHeaders = [:]
    let updatedHeaders = headers != nil ? HTTPHeaders(defaultHeaders.dictionary.merging(headers!.dictionary) { $1 }) : defaultHeaders

    print("URL: \(url)")
    print("Headers: \(updatedHeaders)")

    let response = await AF.request(url,
                                    method: .delete, // Use the DELETE method
                                    headers: updatedHeaders)
                                    .serializingData().response

    let statusCode = response.response?.statusCode ?? 0
    let isSuccess = statusCode < 400
    let json = JSON(response.data ?? Data())

    print("Response Status Code: \(statusCode)")
    print("Response Data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No Data")")

    return (isSuccess, json)
}
