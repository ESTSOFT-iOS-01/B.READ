//
//  SFSymbol.swift
//  B.READ
//
//  Created by 신승재 on 5/31/25.
//

import Foundation

enum SFSymbol {
  case house
  case magnify
  case library
  case record
  case myPage
  case barcode
  case xmark
  case heart
  case star
  case memo
  case bubble
  case bookMark
  case bookMarkFill
  case timer
  case list
  case grid
  case ellipsis
  case trash
  case chevronCompactUp
  case chevronCompactDown
  case chevronLeft
  case chevronRight
  
  var name: String {
    switch self {
    case .house: 
      "house.fill"
    case .magnify:
      "magnifyingglass"
    case .library: 
      "books.vertical.fill"
    case .record:
      "doc.text.magnifyingglass"
    case .myPage:
      "person.fill"
    case .barcode:
      "barcode.viewfinder"
    case .xmark:
      "xmark"
    case .heart:
      "heart.fill"
    case .star:
      "star.fill"
    case .memo:
      "note.text"
    case .bubble:
      "ellipsis.bubble"
    case .bookMark:
      "bookmark"
    case .bookMarkFill:
      "bookmark.fill"
    case .timer:
      "timer"
    case .list:
      "list.bullet"
    case .grid:
      "square.grid.2x2.fill"
    case .ellipsis:
      "ellipsis"
    case .trash:
      "trash"
    case .chevronCompactUp:
      "chevron.compact.up"
    case .chevronCompactDown:
      "chevron.compact.down"
    case .chevronLeft:
      "chevron.left"
    case .chevronRight:
      "chevron.right"
    }
  }
}
