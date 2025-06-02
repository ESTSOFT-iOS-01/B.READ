//
//  ProfileUseCaseTest.swift
//  B.READTests
//
//  Created by 신승재 on 5/19/25.
//

import Foundation
import Testing

@testable import B_READ

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
    
    // MARK: - 임시로 갯수 비교로 수정
    #expect(userInfo.categories.count == categories.count)
  }
  
  @Test("현재 최근 검색어 목록 불러오기")
  func testFetchRecentKeywords() async throws {
    // given
    try await userInfoRepository.createUserInfo(DummyData.userInfo)
    
    // when
    let keywords = try await profileUseCase.fetchRecentKeywords()
    
    // then
    let expected = ["미움받을 용기", "히가시노 게이고"]
    #expect(keywords == expected)
  }
  
  
  @Test("최근 검색어 추가")
  func testAddRecentKeyword() async throws {
    // given
    try await userInfoRepository.createUserInfo(DummyData.userInfo)

    // when
    try await profileUseCase.addRecentKeyword("새로운 것")

    // then
    let keywords = try await profileUseCase.fetchRecentKeywords()
    let expected = ["새로운 것", "미움받을 용기", "히가시노 게이고"]
    #expect(keywords == expected)
  }
  
  @Test("빈 검색어 추가 - 에러 발생")
  func testAddEmptyKeywordThrows() async throws {
    // given
    try await userInfoRepository.createUserInfo(DummyData.userInfo)

    // when-then
    await #expect(throws: ProfileUseCaseError.emptyInput, performing: {
      try await profileUseCase.addRecentKeyword("")
    })
  }
  
  @Test("최근 검색어 추가 - 중복 제거 및 정렬")
  func testAddKeywordWithDuplicationHandling() async throws {
    // given
    try await userInfoRepository.createUserInfo(DummyData.userInfo)
    // 기존: ["히가시노 게이고", "미움받을 용기"]

    // when
    try await profileUseCase.addRecentKeyword("미움받을 용기")

    // then
    let keywords = try await profileUseCase.fetchRecentKeywords()
    let expected = ["미움받을 용기", "히가시노 게이고"] // 중복 제거되고 가장 최근으로 이동
    #expect(keywords == expected)
  }

  @Test("최근 검색어 추가 - 최대 5개 유지")
  func testMaxFiveRecentKeywords() async throws {
    // given
    try await userInfoRepository.createUserInfo(DummyData.userInfo)

    // when
    try await profileUseCase.addRecentKeyword("데미안")
    try await Task.sleep(nanoseconds: 1_000_000_000)
    
    try await profileUseCase.addRecentKeyword("싯다르타")
    try await Task.sleep(nanoseconds: 1_000_000_000)
    
    try await profileUseCase.addRecentKeyword("어린왕자")
    
    try await Task.sleep(nanoseconds: 1_000_000_000)
    try await profileUseCase.addRecentKeyword("미셸푸코")

    // then
    let keywords = try await profileUseCase.fetchRecentKeywords()
    let expected = ["미셸푸코", "어린왕자", "싯다르타", "데미안", "미움받을 용기"]
    #expect(keywords == expected)
  }

  @Test("최근 검색어 삭제")
  func testDeleteRecentKeyword() async throws {
    // given
    try await userInfoRepository.createUserInfo(DummyData.userInfo)

    // when
    try await profileUseCase.deleteRecentKeyword("히가시노 게이고")

    // then
    let keywords = try await profileUseCase.fetchRecentKeywords()
    let expected = ["미움받을 용기"]
    #expect(keywords == expected)
  }
  
  @Test("리스트에 없는 검색어 삭제")
  func testDeleteNonexistentKeyword() async throws {
    // given
    try await userInfoRepository.createUserInfo(DummyData.userInfo)

    // when
    try await profileUseCase.deleteRecentKeyword("이게뭐야")

    // then
    let keywords = try await profileUseCase.fetchRecentKeywords()
    let expected = ["미움받을 용기", "히가시노 게이고"]
    #expect(keywords == expected)
  }
  
  @Test("최근 검색어 전체 삭제")
  func testClearRecentKeywords() async throws {
    // given
    try await userInfoRepository.createUserInfo(DummyData.userInfo)

    // when
    try await profileUseCase.clearRecentKeywords()

    // then
    let keywords = try await profileUseCase.fetchRecentKeywords()
    #expect(keywords.isEmpty)
  }
  
  @Test("빈 최근 검색어 목록에서 전체 삭제 시도")
  func testClearWhenKeywordListIsEmpty() async throws {
    // given
    var emptyUserInfo = DummyData.userInfo
    emptyUserInfo.recentKeywords = []
    try await userInfoRepository.createUserInfo(emptyUserInfo)

    // when
    try await profileUseCase.clearRecentKeywords()

    // then
    let keywords = try await profileUseCase.fetchRecentKeywords()
    #expect(keywords.isEmpty)
  }
  
}
