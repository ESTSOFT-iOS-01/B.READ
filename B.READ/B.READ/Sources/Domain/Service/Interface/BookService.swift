//
//  BookService.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import Foundation

/// 도서 관련 데이터를 가져오는 서비스를 정의한 프로토콜입니다.
protocol BookService {
  
  /// 키워드를 기반으로 도서 목록을 페이징하여 가져옵니다.
  ///
  /// - Parameters:
  ///   - keyword: 검색할 도서 키워드입니다.
  ///   - pageIndex: 불러올 페이지 번호입니다. (기본값: 1)
  /// - Returns: 검색 결과와 페이지네이션 정보가 포함된 `SearchPagnation` 객체
  /// - Throws:
  ///   - `AladinError.serverError`: API가 에러 응답을 반환한 경우
  ///   - `AladinError.decodingError`: 응답 디코딩 실패 시
  ///   - `URLError`: 네트워크 연결 문제 발생 시
  func fetchBookList(for keyword: String, index pageIndex: Int) async throws -> SearchPagnation
  
  /// ISBN을 기반으로 도서 상세 정보를 가져옵니다.
  ///
  /// - Parameter isbn: 도서의 ISBN13 값
  /// - Returns: 도서 상세 정보(`BookDetail`) 객체
  /// - Throws:
  ///   - `AladinError.serverError`: API가 에러 응답을 반환한 경우
  ///   - `AladinError.decodingError`: 도서 항목이 없거나 디코딩 실패 시
  ///   - `URLError`: 네트워크 연결 문제 발생 시
  func fetchBookDetail(isbn: String) async throws -> BookDetail
  
  /// 특정 카테고리의 베스트셀러 도서 목록을 가져옵니다.
  ///
  /// - Parameter category: 알라딘 카테고리 ID (기본값: 0 = 전체)
  /// - Returns: `BestSeller` 객체 배열
  /// - Throws:
  ///   - `AladinError.serverError`: API가 에러 응답을 반환한 경우
  ///   - `AladinError.decodingError`: 응답 디코딩 실패 시
  ///   - `URLError`: 네트워크 연결 문제 발생 시
  func fetchBestSeller(in category: Int) async throws -> [BestSeller]
}
