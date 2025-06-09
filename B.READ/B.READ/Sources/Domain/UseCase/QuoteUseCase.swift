//
//  QuoteUseCase.swift
//  B.READ
//
//  Created by 도민준 on 5/21/25.
//


import Foundation

protocol QuoteUseCase {
  /// 문장을 저장합니다.
  ///
  /// - Parameters:
  ///   - memo: 저장할 `Quote` 객체
  ///   - record: 문장을 저장할 대상 `Record` 객체
  /// - Throws: `RepositoryError.dataNotFound`, `RepositoryError.dataAlreadyExist`, 저장 중 오류 발생 시
  /// - Note: 이미 존재하는 문장의 경우 업데이트하며, 존재하지 않으면 새로 생성합니다.
  func saveQuote(_ quote: Quote, in record: Record) async throws

  /// 특정 ID의 문장을 삭제합니다.
  ///
  /// - Parameter id: 삭제할 `Quote` 엔티티의 고유 식별자(UUID)
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 삭제 대상인 `Quote`가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 삭제 전 대상 확인 과정에서 저장소 조회 중 에러가 발생한 경우
  func removeQuote(id: String) async throws

  /// 단일 문장을 조회합니다.
  ///
  /// - Parameter id: 조회할 `Quote` 엔티티의 고유 식별자(UUID)
  /// - Returns: 조회된 `Quote` 객체
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 해당 ID의 `Quote`가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 조회 과정에서 저장소 조회 중 에러가 발생한 경우
  func fetchQuote(id: String) async throws -> Quote

  /// 특정 도서(ISBN)와 연관된 모든 문장을 최신 작성일 순으로 조회합니다.
  ///
  /// - Parameter isbn: 조회할 도서의 ISBN
  /// - Returns: 해당 ISBN에 속한 `Quote` 배열
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 조회 과정에서 저장소 조회 중 에러가 발생한 경우
  func fetchQuotes(isbn: String) async throws -> [Quote]

  /// 저장된 모든 문장을 최신 작성일 순으로 조회합니다.
  ///
  /// - Returns: 전체 `Quote` 배열
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 조회 과정에서 저장소 조회 중 에러가 발생한 경우
  func fetchAllQuotes() async throws -> [Quote]

  /// ISBN 값을 가지고 도서 제목을 조회합니다.
  ///
  /// - Parameter isbn: 조회할 도서의 ISBN
  /// - Returns: 조회한 도서의 제목
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 조회한 도서 정보가 존재하지 않는경우
  ///   - `RepositoryError.fetchError`: 도서 정보 조회 과정에서 저장소 조회 중 에러가 발생한 경우
  func loadBookTitle(_ isbn: String) async throws -> String
}

/// `QuoteUseCase` 수행 중 발생할 수 있는 비즈니스 검증 오류를 정의합니다.
enum QuoteUseCaseError: LocalizedError, Equatable {
  /// 문장 내용이 빈 문자열인 경우
  case emptyContent
  /// 페이지 번호가 유효 범위를 벗어나는 경우
  case invalidPage(max: Int)

  var errorDescription: String? {
    switch self {
    case .emptyContent:
      return "문장 내용은 빈 문자열일 수 없습니다."
    case .invalidPage(let max):
      return "페이지는 1에서 \(max) 사이여야 합니다."
    }
  }
}
