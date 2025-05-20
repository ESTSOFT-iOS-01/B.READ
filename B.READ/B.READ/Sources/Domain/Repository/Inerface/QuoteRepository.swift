//
//  QuoteRepository.swift
//  B.READ
//
//  Created by 도민준 on 5/20/25.
//

import Foundation

protocol QuoteRepository {
  
  /// Quote를 생성합니다.
  ///
  /// - Parameter quote: 저장할 Quote Entity
  /// - Throws:
  ///   - `RepositoryError.dataAlreadyExist`: 동일한 ID의 데이터가 이미 존재하는 경우
  ///   - `RepositoryError.fetchError`: 기존 데이터 확인 과정에서 에러가 발생한 경우
  func createQuote(_ quote: Quote) async throws
  
  /// Quote를 갱신합니다.
  ///
  /// - Parameter quote: 업데이트할 Quote Entity
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 수정 대상이 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func updateQuote(_ quote: Quote) async throws
  
  /// Quote를 조회합니다.
  ///
  /// - Returns: 저장된 Quote Entity 배열
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func fetchQuote() async throws -> Quote
  
  /// Quote를 삭제합니다.
  ///
  /// - Parameter quote: 삭제할 Quote Entity
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 삭제 대상이 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func deleteQuote(_ quote: Quote) async throws
}
