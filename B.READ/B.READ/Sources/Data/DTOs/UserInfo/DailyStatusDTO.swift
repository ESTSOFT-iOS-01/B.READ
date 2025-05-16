//
//  DailyStatusDTO.swift
//  B.READ
//
//  Created by 신승재 on 5/16/25.
//

import Foundation
import SwiftData

@Model
final class DailyStatusDTO {
  var weekday: Int
  var isCompleted: Bool
  
  init(weekday: Int, isCompleted: Bool) {
    self.weekday = weekday
    self.isCompleted = isCompleted
  }
  
  convenience init(_ data: DailyStatus) {
    self.init(
      weekday: data.weekday,
      isCompleted: data.isCompleted
    )
  }
}

extension DailyStatusDTO {
  func toEntity() -> DailyStatus {
    return DailyStatus(
      weekday: self.weekday,
      isCompleted: self.isCompleted
    )
  }
}
