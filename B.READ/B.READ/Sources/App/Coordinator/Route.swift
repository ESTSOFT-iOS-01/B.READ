//
//  Route.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import SwiftUI



enum MainRoute: Hashable {
  
  // MARK: - Search
  case barcode
  case searchBook(isbn: String)
  case searchRecord(id: String)
  
  // MARK: - MyPage
  case insertNickname
  case selectCategory
}


