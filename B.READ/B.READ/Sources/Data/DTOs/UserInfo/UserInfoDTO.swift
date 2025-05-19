//
//  UserInfoDTO.swift
//  B.READ
//
//  Created by 신승재 on 5/16/25.
//

import Foundation
import SwiftData

@Model
final class UserInfoDTO {
  var nickname: String
  
  @Relationship(deleteRule: .cascade)
  var categories: [CategoryDTO]
  
  @Relationship(deleteRule: .cascade)
  var recentKeywords: [KeywordDTO]
  
  var generateCount: Int
  var lastStreakUpdatedAt: Date
  
  @Relationship(deleteRule: .cascade)
  var streak: [DailyStatusDTO]
  
  init(
    nickname: String,
    categories: [CategoryDTO],
    recentKeywords: [KeywordDTO],
    generateCount: Int,
    lastStreakUpdatedAt: Date,
    streak: [DailyStatusDTO]
  ) {
    self.nickname = nickname
    self.categories = categories
    self.recentKeywords = recentKeywords
    self.generateCount = generateCount
    self.lastStreakUpdatedAt = lastStreakUpdatedAt
    self.streak = streak
  }
  
  convenience init(_ data: UserInfo) {
    self.init(
      nickname: data.nickname,
      categories: data.categories.map { CategoryDTO($0) },
      recentKeywords: data.recentKeywords.map { KeywordDTO($0) },
      generateCount: data.generateCount,
      lastStreakUpdatedAt: data.lastStreakUpdatedAt,
      streak: data.streak.map { DailyStatusDTO($0) }
    )
  }
}

extension UserInfoDTO {
  func toEntity() -> UserInfo {
    return UserInfo(
      nickname: self.nickname,
      categories: self.categories.map { $0.toEntity() },
      recentKeywords: self.recentKeywords.map { $0.toEntity() }.sorted { $0.date < $1.date },
      generateCount: self.generateCount,
      lastStreakUpdatedAt: self.lastStreakUpdatedAt,
      streak: self.streak.map { $0.toEntity() }.sorted { $0.weekday < $1.weekday }
    )
  }
}
