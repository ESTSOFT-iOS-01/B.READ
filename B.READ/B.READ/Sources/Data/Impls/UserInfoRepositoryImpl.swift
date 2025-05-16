//
//  UserInfoRepositoryImpl.swift
//  B.READ
//
//  Created by 신승재 on 5/16/25.
//

import Foundation

final class UserInfoRepositoryImpl: UserInfoRepository {
  func createUserInfo(_ userInfo: UserInfo) async throws {
    print("Impl: ", #function)
  }
  
  func fetchUserInfo() async throws -> UserInfo {
    print("Impl: ", #function)
  }
  
  func updateUserInfo(_ userInfo: UserInfo) async throws {
    print("Impl: ", #function)
  }
  
  func deleteUserInfo() async throws {
    print("Impl: ", #function)
  }
  
  
}
