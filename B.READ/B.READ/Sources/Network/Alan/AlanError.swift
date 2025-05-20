//
//  AlanError.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

enum AlanError {
  case decodeError
  case validationError
  case unknownError(Int)
}

extension AlanError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .decodeError:
      "Decode Error"
    case .validationError:
      "Validation Error"
    case .unknownError(let statusCode):
      "Unknown Error, Status Code: \(statusCode)"
    }
  }
}
