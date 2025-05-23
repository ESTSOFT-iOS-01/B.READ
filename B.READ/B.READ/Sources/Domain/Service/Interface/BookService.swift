//
//  BookService.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import Foundation

protocol BookService {
  func fetchBooks(for keyword: String, index pageIndex: Int) async throws -> SearchListDTO
  
  
}
