//
//  HTTPMethod.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

enum HTTPMethod: String {
  case get     = "GET"
  case post    = "POST"
  case put     = "PUT"
  case delete  = "DELETE"
  case patch   = "PATCH"
}

extension URLRequest {
  var method: HTTPMethod? {
    get {
      guard let httpMethod = self.httpMethod else { return nil }
      return HTTPMethod(rawValue: httpMethod)
    }
    set { self.httpMethod = newValue?.rawValue }
  }
}
