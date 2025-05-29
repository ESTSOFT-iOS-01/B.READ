//
//  QuoteUseCase.swift
//  B.READ
//
//  Created by 도민준 on 5/21/25.
//


import Foundation

protocol QuoteUseCase {
  /// 새로운 문장을 추가합니다.
  ///
  /// - Parameter quote: 저장할 `Quote` 엔티티. `content`는 공백 제거 후 빈 문자열일 수 없으며, `page`는 해당 도서의 전체 페이지 수(maxPage) 범위 내여야 합니다.
  /// - Throws:
  ///   - `QuoteUseCaseError.emptyContent`: `content`가 빈 문자열이거나 공백만으로 이루어진 경우
  ///   - `QuoteUseCaseError.invalidPage(max:)`: `page`가 유효한 페이지 범위(1...maxPage)를 벗어나는 경우
  ///   - `RepositoryError.dataAlreadyExist`: 동일 ID의 `Quote`가 이미 저장된 경우
  ///   - `RepositoryError.fetchError`: 페이지 유효성 검증 과정에서 저장소 조회 중 에러가 발생한 경우
  func addQuote(_ quote: Quote) async throws

  /// 기존 문장을 업데이트합니다.
  ///
  /// - Parameter quote: 업데이트할 `Quote` 엔티티. `content`와 `page`는 추가 시와 동일하게 검증됩니다.
  /// - Throws:
  ///   - `QuoteUseCaseError.emptyContent`: `content`가 빈 문자열이거나 공백만으로 이루어진 경우
  ///   - `QuoteUseCaseError.invalidPage(max:)`: `page`가 유효한 페이지 범위를 벗어나는 경우
  ///   - `RepositoryError.dataNotFound`: 수정 대상인 `Quote`가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 페이지 유효성 검증 과정에서 저장소 조회 중 에러가 발생한 경우
  func updateQuote(_ quote: Quote) async throws

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

  /// 페이지 유효성을 검증합니다.(1...maxPage)
  ///
  /// - Parameters:
  ///   - page: 검증할 페이지 번호
  ///   - isbn: 해당 페이지 유효성 검증을 위한 도서의 ISBN
  /// - Throws:
  ///   - `QuoteUseCaseError.invalidPage(max:)`: `page`가 유효한 페이지 범위를 벗어나는 경우
  ///   - `RepositoryError.dataNotFound`: 검증을 위한 도서 정보가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 도서 정보 조회 과정에서 저장소 조회 중 에러가 발생한 경우
  func validatePage(_ page: Int, forISBN isbn: String) async throws

  /// ISBN 으로 해당 도서의 총 페이지 수를 조회합니다.
  ///
  /// - Parameter isbn: 총 페이지 수를 조회할 도서의 ISBN
  /// - Returns: 도서의 `totalPages`
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 해당 ISBN에 대한 도서 정보가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 저장소 조회 중 오류가 발생한 경우
  func pageCount(forISBN isbn: String) async throws -> Int
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
