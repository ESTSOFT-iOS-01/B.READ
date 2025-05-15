//
//  ProgressState.swift
//  B.READ
//
//  Created by 심근웅 on 5/15/25.
//

import SwiftUI

enum ProgressState {
  // TODO: 빵 굽기에 맞는 이름으로 변경
  case raw
  case rare
  case medium
  case wellDone
  
  var label: String {
    switch self {
    case .raw:
      "오븐 예열 중"
    case .rare, .medium, .wellDone:
      "빵 굽는 중"
    }
  }
  
  var color: Color {
    switch self {
    case .raw:
        .backgroundDefault
    case .rare:
        .brown2
    case .medium:
        .brown3
    case .wellDone:
        .brown4
    }
  }
  
  var image: Image {
    switch self {
    case .raw:
      Image(.bread0)
    case .rare:
      Image(.bread1)
    case .medium:
      Image(.bread2)
    case .wellDone:
      Image(.bread3)
    }
  }
  
}
