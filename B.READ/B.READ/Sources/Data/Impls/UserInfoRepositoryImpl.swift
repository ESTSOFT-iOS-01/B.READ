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
  func createUserInfo(_ userInfo: UserInfo) throws {
    print("Impl: ", #function)
    
    if let _ = try findUserInfo() {
      throw RepositoryError.dataAlreadyExist
    }
    
    let model = UserInfoDTO(userInfo)
    modelContext.insert(model)
    try modelContext.save()
  }
  
  func fetchUserInfo() throws -> UserInfo {
    print("Impl: ", #function)
    
    guard let data = try findUserInfo() else {
      throw RepositoryError.dataNotFound
    }
    
    return data.toEntity()
  }
  
  func updateUserInfo(_ userInfo: UserInfo) throws {
    print("Impl: ", #function)
    
    guard let data = try findUserInfo() else {
      throw RepositoryError.dataNotFound
    }
    
    data.nickname = userInfo.nickname
    data.generateCount = userInfo.generateCount
    data.lastStreakUpdatedAt = userInfo.lastStreakUpdatedAt
    
    // Category 업데이트
    let oldCategories = data.categories
    let newCategories = userInfo.categories
    
    for item in oldCategories {
      if !newCategories.contains(where: { $0.id == item.id }) {
        modelContext.delete(item)
        data.categories.removeAll(where: { $0.id == item.id })
      }
    }
    
    for item in newCategories {
      if !oldCategories.contains(where: { $0.id == item.id }) {
        let newItem = CategoryDTO(item)
        data.categories.append(newItem)
      }
    }
    
    // Keyword 업데이트
    let oldKeywords = data.recentKeywords
    let newKeywords = userInfo.recentKeywords
    
    for item in oldKeywords {
      if !newKeywords.contains(where: { $0 == item.toEntity() }) {
        modelContext.delete(item)
        data.recentKeywords.removeAll(where: { $0 == item })
      }
    }
    
    for item in newKeywords {
      if !oldKeywords.contains(where: { $0.toEntity() == item }) {
        let newItem = KeywordDTO(item)
        data.recentKeywords.append(newItem)
      }
    }
    
    // Streak 업데이트
    let oldStreak = data.streak
    let newStreak = userInfo.streak
    
    for item in oldStreak {
      if !newStreak.contains(where: { $0 == item.toEntity() }) {
        modelContext.delete(item)
        data.streak.removeAll(where: { $0 == item })
      }
    }
    
    for item in newStreak {
      if !oldStreak.contains(where: { $0.toEntity() == item }) {
        let newItem = DailyStatusDTO(item)
        data.streak.append(newItem)
      }
    }
    
    try modelContext.save()
  }
  
  func deleteUserInfo() throws {
    print("Impl: ", #function)
    
    guard let data = try findUserInfo() else {
      throw RepositoryError.dataNotFound
    }
    
    modelContext.delete(data)
    try modelContext.save()
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
