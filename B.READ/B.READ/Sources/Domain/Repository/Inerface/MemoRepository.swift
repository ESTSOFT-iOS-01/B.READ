//
//  MemoRepository.swift
//  B.READ
//
//  Created by 신승재 on 5/30/25.
//

import Foundation

protocol MemoRepository {
  
  /// Memo를 생성합니다.
  ///
  /// - Parameter memo: Memo Entity
  /// - Throws:
  ///   - `RepositoryError.dataAlreadyExist`: 동일한 ID의 메모가 이미 존재하는 경우
  ///   - `RepositoryError.fetchError`: 기존 데이터 조회 중 에러가 발생한 경우
  func createMemo(_ memo: Memo) async throws
  
  /// 특정 ID에 해당하는 Memo를 조회합니다.
  ///
  /// - Parameter id: 조회할 Memo의 ID
  /// - Returns: Memo Entity
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 해당 메모가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 조회 중 에러가 발생한 경우
  func fetchMemo(id: String) async throws -> Memo
  
  /// 전체 Memo를 최신순으로 조회합니다.
  ///
  /// - Returns: Memo Entity 리스트
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 조회 중 에러가 발생한 경우
  func fetchAllMemos() async throws -> [Memo]
  
  /// 특정 ISBN에 해당하는 Memo를 조회합니다.
  ///
  /// - Parameter isbn: 조회할 Memo의 ISBN
  /// - Returns: 해당 ISBN을 가진 Memo Entity 리스트
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 조회 중 에러가 발생한 경우
  func fetchAllMemos(isbn: String) async throws -> [Memo]
  
  /// 특정 텍스트를 포함한 Memo를 조회합니다.
  ///
  /// - Parameter text: 검색할 키워드 텍스트
  /// - Returns: `content`에 해당 텍스트를 포함한 Memo Entity 리스트
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 조회 중 에러가 발생한 경우
  func fetchAllMemos(containg text: String) async throws -> [Memo]
  
  /// Memo를 수정합니다.
  ///
  /// - Parameter memo: 수정할 Memo Entity
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 해당 메모가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 저장 중 에러가 발생한 경우
  func updateMemo(_ memo: Memo) async throws
  
  /// 특정 ID에 해당하는 Memo를 삭제합니다.
  ///
  /// - Parameter id: 삭제할 Memo의 ID
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 해당 메모가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 삭제 중 에러가 발생한 경우
  func deleteMemo(id: String) async throws
  
}
