//
//  DummyData.swift
//  B.READTests
//
//  Created by 신승재 on 5/17/25.
//

import Foundation

enum DummyData {
  static var userInfo = UserInfo(
    nickname: "모옹피",
    categories: [
      Category(id: 101, name: "소설"),
      Category(id: 203, name: "에세이")
    ],
    recentKeywords: [
      Keyword(date: Date().addingTimeInterval(-86400 * 2), value: "히가시노 게이고"),
      Keyword(date: Date().addingTimeInterval(-86400 * 1), value: "미움받을 용기")
    ],
    generateCount: 3,
    lastStreakUpdatedAt: Date(),
    streak: (0...6).map { index in
      DailyStatus(weekday: index, isCompleted: index % 2 == 0)
    }
  )
}
