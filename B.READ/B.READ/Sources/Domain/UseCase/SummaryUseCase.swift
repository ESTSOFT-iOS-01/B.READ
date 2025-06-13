//
//  SummaryUseCase.swift
//  B.READ
//
//  Created by 김도연 on 6/9/25.
//

import Foundation

/// 독서 요약 기능을 담당하는 UseCase입니다.
protocol SummaryUseCase {
  
  /// 사용자가 생성한 요약을 저장합니다.
  ///
  /// - Parameters:
  ///   - summary: 저장할 요약 객체
  ///   - record: 해당 요약이 속한 독서 기록
  /// - Throws: 저장 실패 시 오류를 발생시킵니다.
  func saveSummary(_ summary: AlanSummary, in record: Record) async throws
  
  /// AI 기반으로 요약을 생성합니다.
  ///
  /// - Parameter record: 요약을 생성할 대상 독서 기록
  /// - Returns: 생성된 요약 객체
  /// - Throws:
  ///   - SummaryUseCaseError.promptError: AI 응답이 오류 메시지를 반환한 경우
  ///   - SummaryUseCaseError.fatalError: 3회 재시도 후에도 실패한 경우
  func generateSummary(in record: Record) async throws -> AlanSummary
  
  /// 특정 ID에 해당하는 요약을 조회합니다.
  ///
  /// - Parameter id: 조회할 요약의 ID
  /// - Returns: 조회된 요약 객체
  /// - Throws: Repository 또는 UseCase 내부 오류 발생 시
  func fetchSummary(id: String) async throws -> AlanSummary
  
  /// 전체 요약 목록을 조회합니다.
  ///
  /// - Returns:
  ///   - `Record Entity`: 메모,문장,요약노트를 가진 독서 기록
  ///   - `Book`: 요약노트의 책 정보
  /// - Throws: 조회 실패 시 오류를 발생시킵니다.
  func fetchAllSummary() async throws -> [(Record, Book)]
}

/// 요약 생성 및 조회 과정에서 발생할 수 있는 오류 타입입니다.
enum SummaryUseCaseError {
  /// AI로부터 오류 메시지가 반환된 경우
  case promptError(String)
  /// JSON 디코딩 등 파싱 오류
  case parsingError
  /// 3회 재시도에도 실패한 경우
  case fatalError
}

extension SummaryUseCaseError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case let .promptError(desp):
      desp
    case .parsingError:
      "Parsing error"
    case .fatalError:
      "3번 시도 실패"
    }
  }
}

/// AI 요약 응답 모델입니다.
struct ResponseSummary: Decodable {
  let summary: String
  let feelingTags: [String]
  
  enum CodingKeys: String, CodingKey {
    case summary = "Summary"
    case feelingTags
  }
}

/// AI 오류 응답 모델입니다.
struct ErrorResponse: Decodable {
  let error: String
}
