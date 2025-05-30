//
//  SearchUseCase.swift
//  B.READ
//
//  Created by 김도연 on 5/30/25.
//

import Foundation

/// 사용자의 검색 요청을 처리하는 UseCase입니다.
/// 외부 API 또는 내부 저장소를 통해 도서 정보를 검색합니다.
protocol SearchUseCase {
  
  /// ISBN을 기반으로 외부 API에서 도서 상세 정보를 가져옵니다.
  ///
  /// - Parameter isbn: 도서의 ISBN(13자리 문자열)
  /// - Returns: ISBN에 해당하는 `BookDetail` 객체
  /// - Throws: 네트워크 오류, 디코딩 오류, 또는 API 오류 발생 시 예외를 던집니다.
  func searchBookDetail(isbn: String) async throws -> BookDetail

  /// 검색어를 기반으로 외부 API에서 도서 목록을 페이징하여 검색합니다.
  ///
  /// - Parameters:
  ///   - query: 검색할 키워드 문자열
  ///   - page: 검색 결과의 페이지 번호 (1부터 시작)
  /// - Returns: 검색된 도서 목록과 페이지네이션 정보를 포함한 `SearchPagnation` 객체
  /// - Throws: 네트워크 오류, 디코딩 오류, 또는 API 오류 발생 시 예외를 던집니다.
  func searchBooksFromService(query: String, page: Int) async throws -> SearchPagnation

  /// 검색어를 기반으로 내부 저장소에 등록된 도서 목록을 검색합니다.
  ///
  /// - Parameter query: 검색할 키워드 문자열 (책 제목 기준)
  /// - Returns: 검색된 `Record`와 해당 ISBN에 대응하는 `Book` 객체의 튜플 배열
  /// - Throws: 저장소 조회 실패 또는 book fetch 실패 시 예외를 던집니다.
  func searchBooksFromRepository(query: String) async throws -> [(Record, Book)]
}
