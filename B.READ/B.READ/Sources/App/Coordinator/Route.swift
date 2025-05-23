//
//  Route.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import SwiftUI

enum SearchRoute: Hashable {
  case barcode
  case searchBook(isbn: String)
  case searchRecord(id: String)
}

enum OnboardingRoute: Hashable {
  case login
  case insertNickname
  case selectCategory
  case mainTabBar
}
