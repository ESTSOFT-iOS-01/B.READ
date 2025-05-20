//
//  AlanRouter.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

// TODO: 프로토콜을 만들면 좋을것 같다.
enum AlanRouter {
  
  case question(String)
  case resetState
  
  // MARK: - BaseURL
  private var baseURL: URL {
    AlanAPI.baseURL
  }
  
  // MARK: - Path
  private var path: String {
    switch self {
    case .question:
      "/api/v1/question"
    case .resetState:
      "/api/v1/reset-state"
    }
  }
  
  // MARK: - Method(TODO Method 열거형 만들기)
  private var method: String {
    switch self {
    case .question:
      "GET"
    case .resetState:
      "DELETE"
    }
  }
  
  
  // MARK: - QueryItems(TODO 여긴 어떻게 할지 고민)
  private var queryItems: [URLQueryItem]? {
    switch self {
    case .question(let prompt):
      let queryItems = [
        URLQueryItem(name: "content", value: prompt),
        URLQueryItem(name: "client_id", value: Bundle.ALAN_CLIENT_ID)
      ]
      return queryItems
      
    case .resetState:
      return nil
    }
  }
  
  
  // MARK: - Parameters(TODO 파라미터 구조체..)
  private var parameters: [String: String]? {
    switch self {
    case .question:
      return nil
    case .resetState:
      let params = ["client_id": Bundle.ALAN_CLIENT_ID]
      return params
    }
  }
  
  // MARK: - asURLRequest(이거는 프로토콜에 넣어야겠다)
  func asURLRequest() throws -> URLRequest {
    var components = URLComponents(
      url: baseURL.appendingPathComponent(path),
      resolvingAgainstBaseURL: false
    )!
    components.queryItems = queryItems
    
    var request = URLRequest(url: components.url!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = method
    
    if let parameters {
      request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
    }
    
    return request
  }
}
