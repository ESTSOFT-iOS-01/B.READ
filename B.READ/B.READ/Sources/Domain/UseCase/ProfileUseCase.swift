//
//  ProfileUseCase.swift
//  B.READ
//
//  Created by 신승재 on 5/19/25.
//

import Foundation

protocol ProfileUseCase {
  
  /// 유저의 닉네임을 설정합니다.
  /// - Parameter nickname: 설정할 닉네임 문자열
  /// - Throws: `RepositoryError.dataNotFound`, `RepositoryError.dataAlreadyExist`, 저장 중 오류 등
  func setNickname(_ nickname: String) async throws
  
  /// 유저의 관심 분야(카테고리)를 설정합니다.
  /// - Parameter categories: 선택된 카테고리 타입 배열
  /// - Throws: `RepositoryError.dataNotFound` 등 저장 중 오류
  func setCategory(_ categories: [CategoryType]) async throws
  
  /// 저장된 유저 정보를 불러옵니다.
  /// - Returns: 저장된 `UserInfo` 객체
  /// - Throws: `RepositoryError.dataNotFound` 등 조회 중 오류
  func fetchUserInfo() async throws -> UserInfo
  
  /// 저장된 최근 검색어를 불러옵니다.
  /// - Returns: 최근 검색어 문자열 배열 (최신순)
  /// - Throws: `RepositoryError.dataNotFound` 등 조회 중 오류
  func fetchRecentKeywords() async throws -> [String]
  
  /// 새로운 최근 검색어를 추가합니다. 중복된 키워드는 제거 후 최상단에 삽입되며, 최대 5개까지만 유지됩니다.
  /// - Parameter keyword: 추가할 검색어
  /// - Throws: `ProfileUseCaseError.emptyInput` 검색어가 비어 있는 경우
  ///           `RepositoryError.dataNotFound` 등 조회 중 오류
  func addRecentKeyword(_ keyword: String) async throws
  
  /// 특정 검색어를 최근 검색어 목록에서 삭제합니다.
  /// - Parameter value: 삭제할 검색어 문자열
  /// - Throws: `RepositoryError.dataNotFound` 등 조회 중 오류
  func deleteRecentKeyword(_ value: String) async throws
  
  /// 저장된 모든 최근 검색어를 삭제합니다.
  /// - Throws: `RepositoryError.dataNotFound` 등 조회 중 오류
  func clearRecentKeywords() async throws
}

// MARK: - ProfileUseCaseError
enum ProfileUseCaseError {
  case emptyInput
}

extension ProfileUseCaseError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .emptyInput:
      "저장할 검색어가 없습니다."
    }
  }
}
