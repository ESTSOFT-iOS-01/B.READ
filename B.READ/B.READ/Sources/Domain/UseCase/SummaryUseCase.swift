//
//  SummaryUseCase.swift
//  B.READ
//
//  Created by 김도연 on 6/9/25.
//

import Foundation

protocol SummaryUseCase {
  func saveSummary(_ summary: AlanSummary, in record: Record) async throws
  
  func generateSummary(in record: Record) async throws -> AlanSummary
  
  func fetchSummary() async throws -> AlanSummary
  
  func fetchAllSummary() async throws -> [AlanSummary]
}
