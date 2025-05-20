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
  
  @Test("Request Question API Cancel")
  func requestCancel() throws {
    Task {
      let cancellableTask = Task {
        await #expect(throws: URLError(.cancelled), performing: {
          try await alanService.request(prompt: "hello")
        })
      }
      
      // 3초 대기 후 취소
      try await Task.sleep(nanoseconds: 3000_000_000)
      cancellableTask.cancel()
    }
  }
  
  @Test("Request Reset API")
  func requestReset() async throws {
    try await alanService.reset()
  }
}
