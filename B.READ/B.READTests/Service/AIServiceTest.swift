//
//  AIServiceTest.swift
//  B.READTests
//
//  Created by 신승재 on 5/20/25.
//

import Foundation
import Testing

struct AIServiceTest {
  
  private let alanService: AIService
  
  init() {
    self.alanService = AlanService()
  }
  
  @Test("Request Question API")
  func requestQuestion() async throws {
    let response = try await alanService.request(prompt: "hello")
    
    print(response)
  }
  
  @Test("Request Reset API")
  func requestReset() async throws {
    try await alanService.reset()
  }
}
