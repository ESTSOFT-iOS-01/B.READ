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
  
  @Test
  func test() async throws {
    let _ = try await alanService.request(prompt: "hello")
  }
}
