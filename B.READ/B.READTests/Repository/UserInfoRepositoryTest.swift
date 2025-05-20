//
//  UserInfoRepositoryTest.swift
//  B.READTests
//
//  Created by 신승재 on 5/17/25.
//

import Foundation
import Testing

struct UserInfoRepositoryTest {
  
  private let userInfoRepository: UserInfoRepository
  
  init() {
    //userInfoRepository = UserInfoRepositoryStub()
    let storage = SwiftDataTestStorage()
    userInfoRepository = UserInfoRepositoryImpl(modelContainer: storage.modelContainer)
  }
  

  @Test("UserInfo Create Test")
  func createUserInfo() async throws {
    
    try await userInfoRepository.createUserInfo(DummyData.userInfo)
    let fetchedUserInfo = try await userInfoRepository.fetchUserInfo()
    
    #expect(fetchedUserInfo == DummyData.userInfo)
  }
  
  @Test("UserInfo Create Error Test - Data Already Exists")
  func createUserInfoDataAlreadyExist() async throws {
    try await userInfoRepository.createUserInfo(DummyData.userInfo)

    await #expect(throws: RepositoryError.dataAlreadyExist, performing: {
      try await userInfoRepository.createUserInfo(DummyData.userInfo)
    })
  }
  
  @Test("UserInfo Fetch Error Test - Data Not Found")
  func fetchUserInfoDataNotFound() async throws {
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await userInfoRepository.fetchUserInfo()
    })
  }
  
  @Test("UserInfo All Update Test")
  func updateAllUserInfo() async throws {
    
    try await userInfoRepository.createUserInfo(DummyData.userInfo)
    
    let updatedUserInfo = UserInfo(
      nickname: "업데이트 데이타 ㅋ",
      categories: [Category(id: 999, name: "테스트")],
      recentKeywords: [],
      generateCount: 7,
      lastStreakUpdatedAt: Date(),
      streak: []
    )

    try await userInfoRepository.updateUserInfo(updatedUserInfo)

    let fetchedUserInfo = try await userInfoRepository.fetchUserInfo()
    #expect(fetchedUserInfo == updatedUserInfo)
  }
  
  @Test("UserInfo Partial Update Test - streak")
  func updatePartialUserInfoStreak() async throws {
    
    try await userInfoRepository.createUserInfo(DummyData.userInfo)
    
    var updatedUserInfo = DummyData.userInfo
    updatedUserInfo.streak = updatedUserInfo.streak.map {
        DailyStatus(weekday: $0.weekday, isCompleted: false)
    }

    try await userInfoRepository.updateUserInfo(updatedUserInfo)

    let fetchedUserInfo = try await userInfoRepository.fetchUserInfo()
    #expect(fetchedUserInfo == updatedUserInfo)
  }
  
  @Test("UserInfo Partial Update Test - Keywords")
  func updatePartialUserInfoKeyword() async throws {
    
    try await userInfoRepository.createUserInfo(DummyData.userInfo)
    
    var updatedUserInfo = DummyData.userInfo
    updatedUserInfo.recentKeywords = [
      Keyword(date: Date().addingTimeInterval(-86400 * 4), value: "싯다르타"),
      Keyword(date: Date().addingTimeInterval(-86400 * 3), value: "데미안")
    ]

    try await userInfoRepository.updateUserInfo(updatedUserInfo)

    let fetchedUserInfo = try await userInfoRepository.fetchUserInfo()
    #expect(fetchedUserInfo == updatedUserInfo)
  }
  
  @Test("UserInfo Update Error Test - Data Not Found")
  func updateUserInfoDataNotFound() async throws {
    let nonExistentUser = DummyData.userInfo

    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await userInfoRepository.updateUserInfo(nonExistentUser)
    })
  }
  
  @Test("UserInfo Delete Test")
  func deleteUserInfo() async throws {
    
    try await userInfoRepository.createUserInfo(DummyData.userInfo)
    try await userInfoRepository.deleteUserInfo()
    
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await userInfoRepository.fetchUserInfo()
    })
  }
  
  @Test("UserInfo Delete Error Test - Data Not Found")
  func deleteUserInfoDataNotFound() async throws {
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await userInfoRepository.deleteUserInfo()
    })
  }
}
