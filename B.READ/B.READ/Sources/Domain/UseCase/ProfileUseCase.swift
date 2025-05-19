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
}
