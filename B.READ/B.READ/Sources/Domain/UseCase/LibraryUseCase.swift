//
//  LibraryUseCase.swift
//  B.READ
//
//  Created by 심근웅 on 5/26/25.
//

import Foundation

protocol LibraryUseCase {
  
  /// 독서 기록을 저장합니다.
  ///
  /// - Parameter
  ///   - `record`: Record Entity,
  ///   - `book`: Book Entity
  /// - Throws:
  ///   - `RepositoryError.dataAlreadyExist`: 이미 독서 기록이 존재하는 경우
  ///   - `RepositoryError.fetchError`: 기존 데이터를 조회하는 과정에서 에러가 발생한 경우
  /// - Note: Todo. 도로시
  func saveRecord(record: Record, book: Book) async throws
  
  /// 독서 기록을 수정합니다.
  ///
  /// - Parameter record: Record Entity
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 기존 데이터를 조회하는 과정에서 에러가 발생한 경우
  /// - Note: `RepositoryError.dataNotFound`의 경우, RepositoryError.createRecord를 호출해 새 데이터를 생성합니다.
  func editRecord(_ record: Record) async throws
  
  /// 독서 기록을 삭제합니다.
  ///
  /// - Parameter record: Record Entity
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 삭제할 독서 기록이 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func deleteRecord(_ record: Record) async throws
  
  /// 특정 독서 기록을 조회합니다.
  ///
  /// - Parameter recordID: 조회할 독서 기록의 ID
  /// - Returns: (Record Entity, Book Entity)
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 조회할 독서 기록이 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func loadRecord(_ recordID: String, _ isbn: String) async throws -> (Record, Book)
  
  /// 전체 독서 기록 목록을 조회합니다.
  ///
  /// - Returns: [(Record Entity, Book Entity)]
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func loadRecordList() async throws -> [(Record, Book)]
  
  /// 최근 업데이트한 `읽는 중` 상태의 독서 기록을 조회합니다.
  ///
  /// - Parameter maxCount: 반환할 독서 기록의 최대 개수 (Int)
  /// - Returns: [(Record Entity, Book Entity)]
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  /// - Note: Todo. 몽피
  func loadRecentUpdatedReadingRecord(maxCount: Int) async throws -> [(Record, Book)]
}
