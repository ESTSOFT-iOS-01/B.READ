//
//  SearchUseCase.swift
//  B.READ
//
//  Created by 김도연 on 5/30/25.
//

import Foundation

protocol SearchUseCase {
  /// ISBN으로 외부 API에서 책 정보를 가져온다.
  func searchBookDetail(isbn: String) async throws -> BookDetail

  /// 쿼리로 외부 API에서 책 목록을 검색한다.
  func searchBooksFromService(query: String) async throws -> SearchPagnation

  /// 쿼리로 내부 저장소에서 등록된 책 목록을 검색한다.
  func searchBooksFromRepository(query: String) async throws -> [Record]
}
