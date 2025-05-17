//
//  UserInfoRepositoryTests.swift
//  B.READTests
//
//  Created by 신승재 on 5/17/25.
//

import Testing

struct UserInfoRepositoryTests {
  
  private let userInfoRepository: UserInfoRepository
  private let baseDummyData: UserInfo
  
  init() {
    userInfoRepository = UserInfoRepositoryStub()
  }
  
  @Test
  func create() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
  }
  
}
