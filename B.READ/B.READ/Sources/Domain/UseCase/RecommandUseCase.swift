//
//  RecommandUseCase.swift
//  B.READ
//
//  Created by 김도연 on 6/1/25.
//

import Foundation

/// 도서를 추천하는 요청을 처리하는 UseCase입니다.
protocol RecommandUseCase {
  
  /// 특정 카테고리의 베스트셀러 도서 목록을 가져옵니다.
  ///
  /// - Parameter category: 알라딘 카테고리 ID (기본값: 0 = 전체)
  /// - Returns: `BestSeller` 객체 배열
  /// - Throws:
  ///   - `AladinError.serverError`: API가 에러 응답을 반환한 경우
  ///   - `AladinError.decodingError`: 응답 디코딩 실패 시
  ///   - `URLError`: 네트워크 연결 문제 발생 시
  func requestBestSeller(in category: Int) async throws -> [BestSeller]
}
