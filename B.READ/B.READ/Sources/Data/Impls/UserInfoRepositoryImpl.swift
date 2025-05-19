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

    data.nickname = userInfo.nickname
    data.generateCount = userInfo.generateCount
    data.lastStreakUpdatedAt = userInfo.lastStreakUpdatedAt

    // Cateogry
    let oldCategories = data.categories
    let newCategories = userInfo.categories
    
    for item in oldCategories {
      if !newCategories.contains(where: { $0.id == item.id }) {
        modelContext.delete(item)
      }
    }

    for item in newCategories {
      if !oldCategories.contains(where: { $0.id == item.id }) {
        let newItem = CategoryDTO(item)
        data.categories.append(newItem)
      }
    }

    // Keyword
    let oldKeywords = data.recentKeywords
    let newKeywords = userInfo.recentKeywords

    for item in oldKeywords {
      if !newKeywords.contains(where: { $0 == item.toEntity() }) {
        modelContext.delete(item)
      }
    }

    for item in newKeywords {
      if !oldKeywords.contains(where: { $0.toEntity() == item }) {
        let newItem = KeywordDTO(item)
        data.recentKeywords.append(newItem)
      }
    }

    // Streak
    let oldStreak = data.streak
    let newStreak = userInfo.streak

    for item in oldStreak {
      if !newStreak.contains(where: { $0 == item.toEntity() }) {
        modelContext.delete(item)
      }
    }

    for item in newStreak {
      if !oldStreak.contains(where: { $0.toEntity() == item }) {
        let newItem = DailyStatusDTO(item)
        data.streak.append(newItem)
      }
    }
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
