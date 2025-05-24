//
//  Route.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import SwiftUI

enum OnboardingRoute: Hashable {
  case login
  case insertNickname
  case selectCategory
}

enum SearchRoute: Hashable {
  case barcode
  case searchBook(isbn: String)
  case searchRecord(id: String)
}

enum MyPageRoute: Hashable {
  case insertNickname
  case selectCategory
}
