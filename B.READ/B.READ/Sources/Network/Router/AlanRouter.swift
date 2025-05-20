//
//  AlanRouter.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

enum AlanRouter {
  
  case question(String)
  case resetState
  
  private var baseURL: URL {
    AlanAPI.baseURL
  }
  
  private var path: String {
    switch self {
    case .question:
      "/api/v1/question"
    case .resetState:
      "/api/v1/reset-state"
    }
  }
  
  private var method: String {
    switch self {
    case .question:
      "GET"
    case .resetState:
      "DELETE"
    }
  }
  
  private var queryItems: [URLQueryItem]? {
    switch self {
    case .question(let prompt):
      let queryItems = [
        URLQueryItem(name: "content", value: prompt),
        URLQueryItem(name: "client_id", value: "example Value")
      ]
      return queryItems
      
    case .resetState:
      return nil
    }
  }
  
  private var parameters: Data? {
    switch self {
    case .question(let string):
      return nil
    case .resetState:
      let params = ["client_id": "example Value"]
      return try? JSONSerialization.data(withJSONObject: params)
    }
  }
  
  func asURLRequest() -> URLRequest {
    var components = URLComponents(
      url: baseURL.appendingPathComponent(path),
      resolvingAgainstBaseURL: false
    )!
    components.queryItems = queryItems
    
    var request = URLRequest(url: components.url!)
    request.httpMethod = method
    request.httpBody = parameters
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    return request
  }
}
