//
//  ProfileUseCaseImpl.swift
//  B.READ
//
//  Created by 신승재 on 5/19/25.
//

import Foundation

final class ProfileUseCaseImpl: ProfileUseCase {
  
  private let userInfoRepository: UserInfoRepository
  
  init(userInfoRepository: UserInfoRepository) {
    self.userInfoRepository = userInfoRepository
  }
  
  func setNickname(_ nickname: String) async throws {
    
    var userInfo: UserInfo
    
    do {
      // 1-1. UserInfo가 기존에 존재하는 경우
      userInfo = try await userInfoRepository.fetchUserInfo()
    } catch RepositoryError.dataNotFound {
      // 1-2. UserInfo가 존재하지 않는 경우, 새로운 UserInfo 생성
      userInfo = try await initializeUserInfo()
    }
    
    // 2. 닉네임 수정
    userInfo.nickname = nickname
    // 3. 업데이트
    try await userInfoRepository.updateUserInfo(userInfo)
  }
  
  func setCategory(_ categoryTypes: [CategoryType]) async throws {
    
    // 1. CategoryType -> Category로 변환
    let categries = categoryTypes.map { Category(id: $0.cid, name: $0.name) }
    
    // 2. 카테고리 수정
    var userInfo = try await userInfoRepository.fetchUserInfo()
    userInfo.categories = categries
    
    // 3. 업데이트
    try await userInfoRepository.updateUserInfo(userInfo)
  }
  
  func fetchUserInfo() async throws -> UserInfo {
    return try await userInfoRepository.fetchUserInfo()
  }
  
}

extension ProfileUseCaseImpl {
  private func initializeUserInfo() async throws -> UserInfo {
    let userInfo = UserInfo(
      nickname: "",
      categories: [],
      recentKeywords: [],
      generateCount: 0,
      lastStreakUpdatedAt: .now,
      streak: (0...6).map { DailyStatus(weekday: $0, isCompleted: false) }
    )
    
    try await userInfoRepository.createUserInfo(userInfo)
    
    return userInfo
  }
}
