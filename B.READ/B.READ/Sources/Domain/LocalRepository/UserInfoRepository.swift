//
//  UserInfoRepository.swift
//  B.READ
//
//  Created by 신승재 on 5/16/25.
//

import Foundation

protocol UserInfoRepository {
  
  func createUserInfo(_ userInfo: UserInfo) async throws
  
  func fetchUserInfo() async throws
  
  func updateUserInfo(_ userInfo: UserInfo) async throws
  
  func deleteUserInfo() async throws
  
}
