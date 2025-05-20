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
    
    let request = try AlanRouter.asURLRequest(.question(prompt))()
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw URLError(.badServerResponse)
    }
    
    switch httpResponse.statusCode {
    case 200:
      let response = try JSONDecoder().decode(QuestionResponse.self, from: data)
      return response.content
    case 422:
      throw AlanError.validationError
    default:
      throw AlanError.unknownError(httpResponse.statusCode)
    }
  }
  
  func reset() async throws {
    print("Impl: ", #function)
    
    let request = try AlanRouter.asURLRequest(.resetState)()
    let (_, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw URLError(.badServerResponse)
    }
    
    switch httpResponse.statusCode {
    case 200:
      break
    case 422:
      throw AlanError.validationError
    default:
      throw AlanError.unknownError(httpResponse.statusCode)
    }
  }
}
