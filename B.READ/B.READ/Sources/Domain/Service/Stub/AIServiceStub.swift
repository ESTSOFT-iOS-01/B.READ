//
//  AIServiceStub.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

actor AIServiceStub: AIService {
  
  func request(prompt: String) async throws -> String {
    print("Stub: ", #function)
    return prompt
  }
  
  func reset() async throws {
    print("Stub: ", #function)
  }
  
}
