//
//  AladinError.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import Foundation

/// 알라딘 API 호출 중 발생할 수 있는 에러를 정의한 열거형입니다.
enum AladinError: Error {
  /// 네트워크 오류
  ///
  /// 주로 서버 응답 없음, 연결 끊김 등 URLSession 관련 오류일 때 사용됩니다.
  case networkError(message: String)
  
  /// 디코딩 실패 오류
  ///
  /// JSON 파싱 중 예상과 다른 구조일 때 발생합니다.
  case decodingError(message: String)
  
  /// 서버가 응답한 에러 코드 및 메시지
  ///
  /// HTTP 응답은 200이지만, 내부적으로 API 에러 메시지가 담겨 있을 때 사용됩니다.
  case serverError(code: Int, message: String)
  
  /// 원인을 알 수 없는 오류
  case unknown
}

extension AladinError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case let .networkError(message):
      return message
    case let .decodingError(message):
      return message
    case let .serverError(code, message):
      return "[\(code)] \(message)"
    case .unknown:
      return "알 수 없는 에러입니다."
    }
  }
}
