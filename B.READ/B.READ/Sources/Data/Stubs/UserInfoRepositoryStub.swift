//
//  UserInfoRepositoryStub.swift
//  B.READ
//
//  Created by 신승재 on 5/16/25.
//

import Foundation

final class UserInfoRepositoryStub: UserInfoRepository {
  
  private var storedUserInfo: UserInfo?
  
  func createUserInfo(_ userInfo: UserInfo) async throws {
    guard storedUserInfo == nil else {
      throw RepositoryError.dataAlreadyExist
    }
    storedUserInfo = userInfo
  }
  
  func fetchUserInfo() async throws -> UserInfo {
    guard let userInfo = storedUserInfo else {
      throw RepositoryError.dataNotFound
    }
    return userInfo
  }
  
  func updateUserInfo(_ userInfo: UserInfo) async throws {
    guard storedUserInfo != nil else {
      throw RepositoryError.dataNotFound
    }
    storedUserInfo = userInfo
  }
  
  func deleteUserInfo() async throws {
    guard storedUserInfo != nil else {
      throw RepositoryError.dataNotFound
    }
    storedUserInfo = nil
  }
}
