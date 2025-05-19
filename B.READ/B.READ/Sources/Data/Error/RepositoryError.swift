//
//  RepositoryError.swift
//  B.READ
//
//  Created by 신승재 on 5/16/25.
//

import Foundation

enum RepositoryError {
  case fetchError
  case dataNotFound
  case dataAlreadyExist
}

extension RepositoryError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .fetchError:
      "Fetch error"
    case .dataNotFound:
      "Data not found"
    case .dataAlreadyExist:
      "Data already exist"
    }
  }
}
