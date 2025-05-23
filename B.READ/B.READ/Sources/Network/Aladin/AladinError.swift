//
//  AladinError.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import Foundation

enum AladinError: Error {
  case networkError(message: String)
  case decodingError(message: String)
  case serverError(code: Int, message: String)
  case unknown
}

extension AladinError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case let .networkError(message):
      return message
    case let .decodingError(message):
      return message
    case let .serverError(code, message):
      return "[\(code)] \(message)"
    case .unknown:
      return "알 수 없는 에러입니다."
    }
  }
}
