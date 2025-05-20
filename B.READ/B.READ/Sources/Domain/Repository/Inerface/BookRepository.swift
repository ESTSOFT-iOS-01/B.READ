//
//  BookInfoRepository.swift
//  B.READ
//
//  Created by 심근웅 on 5/20/25.
//

import Foundation

protocol BookRepository {
  
  /// Book을 생성합니다
  ///
  /// - Parameter book: Book Entity
  /// - Throws:
  ///   - `RepositoryError.dataAlreadyExist`: 이미 도서가 존재하는 경우
  ///   - `RepositoryError.fetchError`: 기존 데이터 조회 중 에러가 발생한 경우
  func createBook(_ book: Book) async throws
  
  /// 특정 Book을 조회합니다
  ///
  /// - Parameter isbn: 도서의 ISBN 정보
  /// - Returns: Book Entity
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 도서가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func fetchBook(isbn: String) async throws -> Book
  
  /// 특정 Book을 갱신합니다
  ///
  /// - Parameter book: Book Entity
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 기존 도서가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func updateBook(_ book: Book) async throws
  
  
}
