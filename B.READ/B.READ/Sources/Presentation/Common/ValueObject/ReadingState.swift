//
//  ReadingState.swift
//  B.READ
//
//  Created by 김도연 on 5/18/25.
//  Updated by 심근웅 on 5/31/25.
//

import Foundation

enum ReadingState: Int, CaseIterable, Hashable {
  case notStart = 0
  case reading
  case finished
  
  func imageName(isSelected: Bool) -> String {
    switch (self, isSelected) {
    case (.notStart, false): return "ToReadUnSelected"
    case (.notStart, true):  return "ToReadSelected"
    case (.reading, false): return "ReadingUnSelected"
    case (.reading, true):  return "ReadingSelected"
    case (.finished, false): return "ReadUnSelected"
    case (.finished, true):  return "ReadSelected"
    }
  }
  
  func toEntity() -> ReadState {
    switch self {
    case .notStart: return .toRead
    case .reading: return .reading
    case .finished: return .completed
    }
  }
  
  static func fromEntity(_ entity: ReadState) -> ReadingState {
    switch entity {
    case .toRead: return .notStart
    case .reading: return .reading
    case .completed: return .finished
    }
  }
}

extension ReadingState {
  var preferredHeight: CGFloat {
    switch self {
    case .notStart: return 332
    case .reading:  return 511
    case .finished: return 588
    }
  }
}
