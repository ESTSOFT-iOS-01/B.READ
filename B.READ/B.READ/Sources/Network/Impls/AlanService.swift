//
//  AlanService.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

actor AlanService: AIService {
  func request(prompt: String) async throws -> String {
    print("Impl: ", #function)
    
    let request = AlanRouter.asURLRequest(.question(prompt))
    return "test"
  }
  
  func reset() async throws {
    print("Impl: ", #function)
  }
}
