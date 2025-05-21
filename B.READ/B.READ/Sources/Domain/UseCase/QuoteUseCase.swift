//
//  QuoteUseCase.swift
//  B.READ
//
//  Created by 도민준 on 5/21/25.
//


import Foundation

protocol QuoteUseCase {
  /// 새로운 문장을 추가합니다.
  /// - Throws: 비즈니스 검증 오류 또는 저장소 오류
  func addQuote(_ quote: Quote) async throws

  /// 기존 문장을 업데이트합니다.
  /// - Throws: 비즈니스 검증 오류 또는 저장소 오류
  func updateQuote(_ quote: Quote) async throws

  /// 문장을 삭제합니다.
  /// - Throws: 저장소 오류
  func removeQuote(id: String) async throws

  /// 단일 문장을 조회합니다.
  /// - Throws: 조회 오류
  func fetchQuote(id: String) async throws -> Quote

  /// 특정 도서(ISBN) 문장 전체를 조회합니다.
  /// - Throws: 조회 오류
  func fetchQuotes(isbn: String) async throws -> [Quote]

  /// 모든 문장을 조회합니다.
  /// - Throws: 조회 오류
  func fetchAllQuotes() async throws -> [Quote]

  /// 페이지 유효성(1...maxPage) 검증
  /// - Throws: `QuoteUseCaseError.invalidPage`
  func validatePage(_ page: Int, forISBN isbn: String) async throws
}

/// UseCase 오류 정의
enum QuoteUseCaseError: LocalizedError {
  case emptyContent
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
