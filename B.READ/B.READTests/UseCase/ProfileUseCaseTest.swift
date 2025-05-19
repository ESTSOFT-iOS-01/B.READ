//
//  ProfileUseCaseTest.swift
//  B.READTests
//
//  Created by 신승재 on 5/19/25.
//

import Foundation
import Testing

struct ProfileUseCaseTest {
  
  private let profileUseCase: ProfileUseCase
  private let userInfoRepository: UserInfoRepository
  
  init() {
    let storage = SwiftDataTestStorage()
    self.userInfoRepository = UserInfoRepositoryImpl(modelContainer: storage.modelContainer)
    self.profileUseCase = ProfileUseCaseImpl(userInfoRepository: userInfoRepository)
  }
  
  @Test("Set Nickname Test")
  func setNickname() async throws {
    
    try await userInfoRepository.createUserInfo(DummyData.userInfo)
    
    let nickname = "신몽피1"
    try await profileUseCase.setNickname(nickname)
    
    let userInfo = try await profileUseCase.fetchUserInfo()
    #expect(userInfo.nickname == nickname)
  }
  
  @Test("Set Nickname Test - No Existing UserInfo")
  func setNicknameWithoutUserInfo() async throws {
    let nickname = "신몽피2"
    try await profileUseCase.setNickname(nickname)
    
    let userInfo = try await profileUseCase.fetchUserInfo()
    #expect(userInfo.nickname == nickname)
  }
  
  @Test("Set Category Test")
  func setCategory() async throws {
    
    try await userInfoRepository.createUserInfo(DummyData.userInfo)
    
    let categoryTypes: [CategoryType] = [.artCulture, .classics]
    let categories = categoryTypes.map { Category(id: $0.cid, name: $0.name) }
    try await profileUseCase.setCategory(categoryTypes)
    
    let userInfo = try await profileUseCase.fetchUserInfo()
    #expect(userInfo.categories == categories)
  }
}
