//
//  AlanService.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

final class AlanService: AIService {
  
  func request(prompt: String) async throws -> String {
    print("Impl: ", #function)
    
    let (data, response) = try await NetworkClient.shared.perform(
      AlanRouter.question(prompt),
      decodeType: QuestionResponse.self
    )
    
    switch response.statusCode {
    case 200:
      return data.content
    case 422:
      throw AlanError.validationError
    default:
      throw AlanError.unknownError(response.statusCode)
    }
  }
  
  func reset() async throws {
    print("Impl: ", #function)
    
    let response = try await NetworkClient.shared.performStatusOnly(AlanRouter.resetState)
    
    switch response.statusCode {
    case 200:
      print("초기화 성공")
    case 422:
      throw AlanError.validationError
    default:
      throw AlanError.unknownError(response.statusCode)
    }
  }
}
