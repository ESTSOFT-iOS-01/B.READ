//
//  SharedQuote.swift
//  B.READ
//
//  Created by 도민준 on 6/9/25.
//

import Foundation

struct SharedQuote: Codable, Identifiable {
  let id: String
  let content: String // 문장
  let bookTitle: String // 제목
}
