//
//  SummaryRepository.swift
//  B.READ
//
//  Created by 김도연 on 6/9/25.
//

import Foundation
import SwiftData

/// Summary 관련 데이터 접근을 담당하는 저장소 인터페이스입니다.
protocol SummaryRepository {
  
  /// Summary를 생성합니다.
  ///
  /// - Parameters:
  ///   - summary: 생성할 Summary Entity
  ///   - record: summary가 속할 독서 기록
  /// - Throws:
  ///   - `RepositoryError.dataAlreadyExist`: 동일한 ID의 Summary가 이미 존재하는 경우
  ///   - `RepositoryError.fetchError`: 저장 중 에러가 발생한 경우
  func createSummary(_ summary: AlanSummary, in record: Record) async throws
  
  /// 특정 ID에 해당하는 Summary를 조회합니다.
  ///
  /// - Parameter id: 조회할 Summary의 ID
  /// - Returns: Summary Entity
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 해당 Summary가 존재하지 않는 경우
  ///   - `RepositoryError.fetchError`: 조회 중 에러가 발생한 경우
  func fetchSummary(id: String) async throws -> AlanSummary
  
  /// 전체 Summary를 조회합니다.
  ///
  /// - Returns: Summary Entity 리스트
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 조회 중 에러가 발생한 경우
  func fetchAllSummary() async throws -> [AlanSummary]
}

