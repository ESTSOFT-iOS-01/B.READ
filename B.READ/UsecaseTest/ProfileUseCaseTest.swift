//
//  ProfileUseCaseTest.swift
//  B.READTests
//
//  Created by 신승재 on 5/19/25.
//

import Foundation
import Testing

@testable import B_READ
//
//struct ProfileUseCaseTest {
//  
//  private let profileUseCase: ProfileUseCase
//  private let userInfoRepository: UserInfoRepository
//  
//  init() {
//    let storage = SwiftDataTestStorage()
//    self.userInfoRepository = UserInfoRepositoryImpl(modelContainer: storage.modelContainer)
//    self.profileUseCase = ProfileUseCaseImpl(userInfoRepository: userInfoRepository)
//  }
//  
//  @Test("Set Nickname Test")
//  func setNickname() async throws {
//    
//    try await userInfoRepository.createUserInfo(DummyData.userInfo)
//    
//    let nickname = "신몽피1"
//    try await profileUseCase.setNickname(nickname)
//    
//    let userInfo = try await profileUseCase.fetchUserInfo()
//    #expect(userInfo.nickname == nickname)
//  }
//  
//  @Test("Set Nickname Test - No Existing UserInfo")
//  func setNicknameWithoutUserInfo() async throws {
//    let nickname = "신몽피2"
//    try await profileUseCase.setNickname(nickname)
//    
//    let userInfo = try await profileUseCase.fetchUserInfo()
//    #expect(userInfo.nickname == nickname)
//  }
//  
//  @Test("Set Category Test")
//  func setCategory() async throws {
//    
//    try await userInfoRepository.createUserInfo(DummyData.userInfo)
//    
//    let categoryTypes: [CategoryType] = [.artCulture, .classics]
//    let categories = categoryTypes.map { Category(id: $0.cid, name: $0.name) }
//    try await profileUseCase.setCategory(categoryTypes)
//    
//    let userInfo = try await profileUseCase.fetchUserInfo()
//    #expect(userInfo.categories == categories)
//  }
//  
//  @Test("현재 최근 검색어 목록 불러오기")
//  func 현재_최근_검색어_목록_불러오기() async throws {
//    // given
//    try await userInfoRepository.createUserInfo(DummyData.userInfo)
//    
//    // when
//    let keywords = try await profileUseCase.fetchRecentKeywords()
//    
//    // then
//    let expected = ["미움받을 용기", "히가시노 게이고"]
//    #expect(keywords == expected)
//  }
//  
//  @Test("최근 검색어 추가")
//  func 최근_검색어_추가() async throws {
//    // given
//    try await userInfoRepository.createUserInfo(DummyData.userInfo)
//
//    // when
//    try await profileUseCase.addRecentKeyword("새로운 것")
//
//    // then
//    let keywords = try await profileUseCase.fetchRecentKeywords()
//    let expected = ["새로운 것", "미움받을 용기", "히가시노 게이고"]
//    #expect(keywords == expected)
//  }
//  
//  @Test("빈 검색어 추가 - 에러 발생")
//  func 빈_검색어_추가_시_에러_발생() async throws {
//    // given
//    try await userInfoRepository.createUserInfo(DummyData.userInfo)
//
//    // when-then
//    await #expect(throws: ProfileUseCaseError.emptyInput, performing: {
//      try await profileUseCase.addRecentKeyword("")
//    })
//  }
//  
//  @Test("최근 검색어 추가 - 중복 제거 및 정렬")
//  func 최근_검색어_추가_중복_제거_및_정렬() async throws {
//    // given
//    try await userInfoRepository.createUserInfo(DummyData.userInfo)
//    // 기존: ["히가시노 게이고", "미움받을 용기"]
//
//    // when
//    try await profileUseCase.addRecentKeyword("미움받을 용기")
//
//    // then
//    let keywords = try await profileUseCase.fetchRecentKeywords()
//    let expected = ["미움받을 용기", "히가시노 게이고"] // 중복 제거되고 가장 최근으로 이동
//    #expect(keywords == expected)
//  }
//
//  @Test("최근 검색어 추가 - 최대 5개 유지")
//  func 최근_검색어_추가_최대_5개_유지() async throws {
//    // given
//    try await userInfoRepository.createUserInfo(DummyData.userInfo)
//
//    // when
//    try await profileUseCase.addRecentKeyword("데미안")
//    try await Task.sleep(nanoseconds: 1_000_000_000)
//    
//    try await profileUseCase.addRecentKeyword("싯다르타")
//    try await Task.sleep(nanoseconds: 1_000_000_000)
//    
//    try await profileUseCase.addRecentKeyword("어린왕자")
//    
//    try await Task.sleep(nanoseconds: 1_000_000_000)
//    try await profileUseCase.addRecentKeyword("미셸푸코")
//
//    // then
//    let keywords = try await profileUseCase.fetchRecentKeywords()
//    let expected = ["미셸푸코", "어린왕자", "싯다르타", "데미안", "미움받을 용기"]
//    #expect(keywords == expected)
//  }
//
//  @Test("최근 검색어 삭제")
//  func 최근_검색어_삭제() async throws {
//    // given
//    try await userInfoRepository.createUserInfo(DummyData.userInfo)
//
//    // when
//    try await profileUseCase.deleteRecentKeyword("히가시노 게이고")
//
//    // then
//    let keywords = try await profileUseCase.fetchRecentKeywords()
//    let expected = ["미움받을 용기"]
//    #expect(keywords == expected)
//  }
//  
//  @Test("리스트에 없는 검색어 삭제")
//  func 없는_검색어_삭제() async throws {
//    // given
//    try await userInfoRepository.createUserInfo(DummyData.userInfo)
//
//    // when
//    try await profileUseCase.deleteRecentKeyword("이게뭐야")
//
//    // then
//    let keywords = try await profileUseCase.fetchRecentKeywords()
//    let expected = ["미움받을 용기", "히가시노 게이고"]
//    #expect(keywords == expected)
//  }
//  
//  @Test("최근 검색어 전체 삭제")
//  func 최근_검색어_전체_삭제() async throws {
//    // given
//    try await userInfoRepository.createUserInfo(DummyData.userInfo)
//
//    // when
//    try await profileUseCase.clearRecentKeywords()
//
//    // then
//    let keywords = try await profileUseCase.fetchRecentKeywords()
//    #expect(keywords.isEmpty)
//  }
//  
//  @Test("빈 최근 검색어 목록에서 전체 삭제 시도")
//  func 빈_검색어_목록에서_전체_삭제_시도() async throws {
//    // given
//    var emptyUserInfo = DummyData.userInfo
//    emptyUserInfo.recentKeywords = []
//    try await userInfoRepository.createUserInfo(emptyUserInfo)
//
//    // when
//    try await profileUseCase.clearRecentKeywords()
//
//    // then
//    let keywords = try await profileUseCase.fetchRecentKeywords()
//    #expect(keywords.isEmpty)
//  }
//  
//}
