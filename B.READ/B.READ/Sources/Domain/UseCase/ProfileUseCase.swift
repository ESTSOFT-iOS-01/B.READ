//
//  ProfileUseCase.swift
//  B.READ
//
//  Created by 신승재 on 5/19/25.
//

import Foundation

protocol ProfileUseCase {
  func setNickname(_ nickname: String) async throws
  func setCategory(_ categories: [CategoryType]) async throws
  func fetchUserInfo() async throws -> UserInfo
}
