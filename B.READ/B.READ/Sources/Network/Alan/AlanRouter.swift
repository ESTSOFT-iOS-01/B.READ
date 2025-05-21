//
//  AlanRouter.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

enum AlanRouter: RequestConvertible {
  
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
  
  // MARK: - Method
  private var method: HTTPMethod {
    switch self {
    case .question:
        .get
    case .resetState:
        .delete
    }
  }
  
  
  // MARK: - QueryItems
  private var queryItems: [URLQueryItem]? {
    switch self {
    case .question(let prompt):
      let queryItems = [
        URLQueryItem(name: "content", value: prompt),
        URLQueryItem(name: "client_id", value: AlanAPI.clientID)
      ]
      return queryItems
      
    case .resetState:
      return nil
    }
  }
  
  
  // MARK: - Parameters
  private var parameters: Parameters? {
    switch self {
    case .question:
      return nil
    case .resetState:
      var params = Parameters()
      params["client_id"] = AlanAPI.clientID
      return params
    }
  }
  
  // MARK: - asURLRequest
  func asURLRequest() throws -> URLRequest {

    var components = URLComponents(
      url: baseURL.appendingPathComponent(path),
      resolvingAgainstBaseURL: false
    )!
    components.queryItems = queryItems
    
    var request = URLRequest(url: components.url!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.method = method
    
    if let parameters {
      request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
    }
    
    return request
  }
}
