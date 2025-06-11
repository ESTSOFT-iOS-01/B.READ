//
//  LibraryRepository.swift
//  B.READ
//
//  Created by 심근웅 on 5/20/25.
//

import Foundation

protocol RecordRepository {
  
  /// Record를 생성합니다.
  ///
  /// - Parameter record: Record Entity
  /// - Throws:
  ///   - `RepositoryError.dataAlreadyExist`: 이미 독서 기록이 존재하는 경우
  ///   - `RepositoryError.fetchError`: 기존 데이터를 조회하는 과정에서 에러가 발생한 경우   
  func createRecord(_ record: Record) async throws
  
  /// 전체 Record를 조회합니다.
  ///
  /// - Returns: [Record Entity]
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func fetchAllRecord() async throws -> [Record]
  
  /// 특정 Record를 조회합니다.
  ///
  /// - Parameter id: 독서 기록의 id
  /// - Returns: Record Entity
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 조회할 독서 기록이 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func fetchRecord(id: String) async throws -> Record
  
  /// 최근 업데이트한 `읽는 중` 상태의 독서 기록을 조회합니다.
  ///
  /// - Parameter count: Int 조회할 독서 기록의 최대 개수
  /// - Returns: [Record Entity]
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func fetchRecentReadingRecord(maxCount: Int) async throws -> [Record]
  
  /// 요약 생성을 위해 사용 가능한 `완독` 상태의 독서 기록을 최신순으로 조회합니다.
  ///
  /// - Returns: 요약이 아직 작성되지 않은 가장 최근의 `완독` 상태의 독서 기록 하나
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 해당 조건에 맞는 독서 기록이 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func fetchRecordAvailableForSummary() throws -> Record
  
  /// 특정 Record를 갱신합니다.
  ///
  /// - Parameter record: Record Entity
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 수정할 독서 기록이 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func updateRecord(_ record: Record) async throws
  
  /// 특정 Record를 삭제합니다.
  ///
  /// - Parameter id: 독서 기록의 id
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 삭제할 독서 기록이 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func deleteRecord(_ id: String) async throws
}
