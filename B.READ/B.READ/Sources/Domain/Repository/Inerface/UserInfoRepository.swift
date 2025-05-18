//
//  UserInfoRepository.swift
//  B.READ
//
//  Created by 신승재 on 5/16/25.
//

import Foundation

protocol UserInfoRepository {
  
  /// UserInfo를 생성합니다.
  ///
  /// - Parameter userInfo: UserInfo Entity
  /// - Throws:
  ///   - `RepositoryError.dataAlreadyExist`: 이미 유저 정보가 존재하는 경우
  ///   - `RepositoryError.fetchError`: 기존 데이터를 조회하는 과정에서 에러가 발생한 경우
  func createUserInfo(_ userInfo: UserInfo) async throws
  
  /// UserInfo를 조회합니다.
  ///
  /// - Returns: UserInfo Entity
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 유저 정보가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func fetchUserInfo() async throws -> UserInfo
  
  /// UserInfo를 갱신합니다.
  ///
  /// - Parameter userInfo: UserInfo Entity
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 기존 유저 정보가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func updateUserInfo(_ userInfo: UserInfo) async throws
  
  /// UserInfo를 삭제합니다.
  ///
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 삭제할 유저 정보가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 데이터 조회 중 에러가 발생한 경우
  func deleteUserInfo() async throws
}
