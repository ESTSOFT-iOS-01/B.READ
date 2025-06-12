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
    let categories = categoryTypes.map { Category(id: $0.cid, name: $0.name) }
    
    // 2. 카테고리 수정
    var userInfo = try await userInfoRepository.fetchUserInfo()
    userInfo.categories = categories
    
    // 3. 업데이트
    try await userInfoRepository.updateUserInfo(userInfo)
  }
  
  func fetchUserInfo() async throws -> UserInfo {
    return try await userInfoRepository.fetchUserInfo()
  }
  
  func fetchRecentKeywords() async throws -> [String] {
    try Task.checkCancellation()
    let userInfo = try await userInfoRepository.fetchUserInfo()
    try Task.checkCancellation()
    
    return userInfo.recentKeywords
      .sorted(by: { $0.date > $1.date }) // 정렬
      .map { $0.value } // [string]로 매핑
  }
  
  func addRecentKeyword(_ keyword: String) async throws {
    guard !keyword.isEmpty else {
      throw ProfileUseCaseError.emptyInput
    }
    
    try Task.checkCancellation()
    var userInfo = try await userInfoRepository.fetchUserInfo()
    
    // 1. 중복 값 제거
    try Task.checkCancellation()
    userInfo.recentKeywords.removeAll { $0.value == keyword }
    
    // 2. 새로운 키워드 추가
    let newKeyword = Keyword(date: Date(), value: keyword)
    userInfo.recentKeywords.append(newKeyword)
    
    
    // 3. 최대 5개로 제한
    if userInfo.recentKeywords.count > 5 {
      userInfo.recentKeywords = Array(
        userInfo.recentKeywords
          .sorted(by: { $0.date > $1.date })
          .prefix(5)
      )
    }
    
    try Task.checkCancellation()
    try await userInfoRepository.updateUserInfo(userInfo)
  }
  
  func deleteRecentKeyword(_ value: String) async throws {
    try Task.checkCancellation()
    var userInfo = try await userInfoRepository.fetchUserInfo()
    try Task.checkCancellation()
    
    userInfo.recentKeywords.removeAll { $0.value == value }
    
    try Task.checkCancellation()
    try await userInfoRepository.updateUserInfo(userInfo)
  }
  
  func clearRecentKeywords() async throws {
    try Task.checkCancellation()
    var userInfo = try await userInfoRepository.fetchUserInfo()
    try Task.checkCancellation()
    
    userInfo.recentKeywords.removeAll()
    
    try Task.checkCancellation()
    try await userInfoRepository.updateUserInfo(userInfo)
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
