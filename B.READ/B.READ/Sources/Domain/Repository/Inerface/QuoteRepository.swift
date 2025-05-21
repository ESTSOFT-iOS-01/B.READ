//
//  QuoteRepository.swift
//  B.READ
//
//  Created by 도민준 on 5/20/25.
//

import Foundation

protocol QuoteRepository {
  /// 새로운 Quote를 생성합니다.
  ///
  /// - Parameter quote: 저장할 `Quote` 엔티티
  /// - Throws:
  ///   - `RepositoryError.dataAlreadyExist`: 동일한 ID의 데이터가 이미 존재하는 경우
  ///   - `RepositoryError.fetchError`: 기존 데이터 확인 과정에서 에러가 발생한 경우
  func createQuote(_ quote: Quote) async throws
  
  /// 기존 Quote를 갱신합니다.
  ///
  /// - Parameter quote: 업데이트할 `Quote` 엔티티
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 수정 대상이 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func updateQuote(_ quote: Quote) async throws
  
  /// 지정된 Quote를 삭제합니다.
  ///
  /// - Parameter quote: 삭제할 `Quote` 엔티티
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 삭제 대상이 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func deleteQuote(_ quote: Quote) async throws
  
  // MARK: - Query (Read)
  
  /// 특정 책(ISBN)에 속한 모든 Quote를 최신순으로 조회합니다.
  ///
  /// - Parameter isbn: 조회할 책의 ISBN
  /// - Returns: 해당 ISBN 하위에 저장된 `Quote` 배열
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func fetchQuotes(isbn: String) async throws -> [Quote]
  
  /// UUID로 단일 Quote를 조회합니다.
  ///
  /// - Parameter id: 조회할 Quote의 UUID
  /// - Returns: 조회된 `Quote` 엔티티
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 해당 ID의 데이터가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func fetchQuote(id: UUID) async throws -> Quote
  
  /// 저장된 모든 Quote를 최신순으로 조회합니다.
  ///
  /// - Returns: 저장된 모든 `Quote` 배열
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func fetchAllQuotes() async throws -> [Quote]
}
