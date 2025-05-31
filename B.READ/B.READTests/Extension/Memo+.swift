//
//  Memo+.swift
//  B.READTests
//
//  Created by 신승재 on 5/30/25.
//

import Foundation

extension Memo: Equatable {
  static func == (lhs: Memo, rhs: Memo) -> Bool {
    return lhs.id == rhs.id
  }
}
