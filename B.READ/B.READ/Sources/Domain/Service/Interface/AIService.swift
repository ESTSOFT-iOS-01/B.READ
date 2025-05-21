//
//  AIService.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

protocol AIService {
  func request(prompt: String) async throws -> String
  func reset() async throws
}
