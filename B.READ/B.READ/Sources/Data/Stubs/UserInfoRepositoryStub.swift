//
//  UserInfoRepositoryStub.swift
//  B.READ
//
//  Created by 신승재 on 5/16/25.
//

import Foundation

actor UserInfoRepositoryStub: UserInfoRepository {
  
  private var storedUserInfo: UserInfo?
  
  func createUserInfo(_ userInfo: UserInfo) throws {
    print("Stub: ", #function)
    guard storedUserInfo == nil else {
      throw RepositoryError.dataAlreadyExist
    }
    storedUserInfo = userInfo
  }
  
  func fetchUserInfo() throws -> UserInfo {
    print("Stub: ", #function)
    guard let userInfo = storedUserInfo else {
      throw RepositoryError.dataNotFound
    }
    return userInfo
  }
  
  func updateUserInfo(_ userInfo: UserInfo) throws {
    print("Stub: ", #function)
    guard storedUserInfo != nil else {
      throw RepositoryError.dataNotFound
    }
    storedUserInfo = userInfo
  }
  
  func deleteUserInfo() throws {
    print("Stub: ", #function)
    guard storedUserInfo != nil else {
      throw RepositoryError.dataNotFound
    }
    storedUserInfo = nil
  }
}
