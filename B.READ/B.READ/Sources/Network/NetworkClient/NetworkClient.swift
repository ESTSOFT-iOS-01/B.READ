//
//  NetworkClient.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

final class NetworkClient {
  
  static let shared = NetworkClient()
  
  private init() {}
  
  /// 네트워크 요청을 수행하고, 응답 데이터를 그대로 반환합니다.
  /// - Parameter request: 요청 정보
  /// - Returns: 응답 데이터와 HTTPURLResponse 튜플
  func perform(
    _ request: RequestConvertible
  ) async throws -> (Data, HTTPURLResponse) {
    let urlRequest = try request.asURLRequest()
    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw URLError(.badServerResponse)
    }

    return (data, httpResponse)
  }
  
  /// 네트워크 요청을 수행하고, 응답 데이터를 지정된 타입으로 디코딩합니다.
  /// - Parameters:
  ///   - request: 요청 정보 (`RequestConvertible` 프로토콜을 준수)
  ///   - type: 디코딩할 모델 타입
  /// - Returns: 디코딩된 모델 객체와 HTTPURLResponse 튜플
  /// - Throws: URLSession 오류, 응답 형식 오류, 디코딩 오류
  func perform<T: Decodable>(
    _ request: RequestConvertible,
    decodeType: T.Type
  ) async throws -> (T, HTTPURLResponse) {
    let urlRequest = try request.asURLRequest()
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw URLError(.badServerResponse)
    }
    
    let decoded = try JSONDecoder().decode(T.self, from: data)
    return (decoded, httpResponse)
  }
  
  /// 응답 본문 없이, HTTP 상태 코드만 확인합니다.
  /// - Parameter request: 요청 정보
  /// - Returns: HTTPURLResponse 객체
  func performStatusOnly(
    _ request: RequestConvertible
  ) async throws -> HTTPURLResponse {
    let urlRequest = try request.asURLRequest()
    let (_, response) = try await URLSession.shared.data(for: urlRequest)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw URLError(.badServerResponse)
    }

    return httpResponse
  }
  
  /// 네트워크 요청을 수행하고, 응답 JSON을 String 형태로 반환합니다 (디버깅 용도).
  /// - Parameter request: 요청 정보 (`RequestConvertible` 프로토콜을 준수)
  /// - Returns: 응답 본문을 문자열로 반환
  /// - Throws: URLSession 오류, 응답 형식 오류
  func performDebugString(
    _ request: RequestConvertible
  ) async throws -> (String, HTTPURLResponse) {
    let urlRequest = try request.asURLRequest()
    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw URLError(.badServerResponse)
    }

    let string = String(data: data, encoding: .utf8) ?? "<Invalid UTF-8 Response>"
    return (string, httpResponse)
  }
}

extension NetworkClient {
  func performOrDecodeAladinError<T: Decodable>(
    _ request: RequestConvertible,
    decodeType: T.Type
  ) async throws -> T {
    let urlRequest = try request.asURLRequest()
    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw URLError(.badServerResponse)
    }

    do {
      let decoded = try JSONDecoder().decode(T.self, from: data)
      return decoded
    } catch {
      // 디코딩 실패 → 알라딘 에러 DTO로 다시 시도
      if let aladinError = try? JSONDecoder().decode(AladinErrorDTO.self, from: data) {
        throw AladinError.serverError(code: aladinError.errorCode, message: aladinError.errorMessage)
      } else {
        throw AladinError.decodingError(message: error.localizedDescription)
      }
    }
  }
}
