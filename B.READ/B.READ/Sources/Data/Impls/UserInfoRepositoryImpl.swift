//
//  UserInfoRepositoryImpl.swift
//  B.READ
//
//  Created by 신승재 on 5/16/25.
//

import Foundation
import SwiftData

@ModelActor
actor UserInfoRepositoryImpl: UserInfoRepository {
  func createUserInfo(_ userInfo: UserInfo) async throws {
    print("Impl: ", #function)
    
    if let _ = try findUserInfo() {
      throw RepositoryError.dataAlreadyExist
    }
    
    let model = UserInfoDTO(userInfo)
    modelContext.insert(model)
  }
  
  func fetchUserInfo() async throws -> UserInfo {
    print("Impl: ", #function)
    
    guard let data = try findUserInfo() else {
      throw RepositoryError.dataNotFound
    }
    
    return data.toEntity()
  }
  
  func updateUserInfo(_ userInfo: UserInfo) async throws {
    print("Impl: ", #function)
    
    guard let data = try findUserInfo() else {
      throw RepositoryError.dataNotFound
    }
    
    data.categories.forEach { modelContext.delete($0) }
    data.recentKeywords.forEach { modelContext.delete($0) }
    data.streak.forEach { modelContext.delete($0) }
    
    data.nickname = userInfo.nickname
    data.categories = userInfo.categories.map { CategoryDTO($0) }
    data.recentKeywords = userInfo.recentKeywords.map { KeywordDTO($0) }
    data.generateCount = userInfo.generateCount
    data.lastStreakUpdatedAt = userInfo.lastStreakUpdatedAt
    data.streak = userInfo.streak.map { DailyStatusDTO($0) }
  }
  
  func deleteUserInfo() async throws {
    print("Impl: ", #function)
    
    guard let data = try findUserInfo() else {
      throw RepositoryError.dataNotFound
    }
    
    modelContext.delete(data)
  }
}

extension UserInfoRepositoryImpl {
  /// 저장소에서 `UserInfoDTO`를 조회합니다.
  ///
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 데이터를 조회하는 과정에서 에러가 발생한 경우
  ///
  /// - Returns:
  ///   - `UserInfoDTO?`: 조회된 첫 번째 유저 정보 DTO, 없으면 `nil`
  private func findUserInfo() throws -> UserInfoDTO? {
    let descriptor = FetchDescriptor<UserInfoDTO>()
    
    do {
      return try modelContext.fetch(descriptor).first
    } catch {
      throw RepositoryError.fetchError
    }
  }
}
