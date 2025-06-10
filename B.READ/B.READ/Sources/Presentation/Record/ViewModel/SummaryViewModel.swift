//
//  SummaryViewModel.swift
//  B.READ
//
//  Created by 김도연 on 6/10/25.
//

import Foundation
import SwiftUI

enum SummaryState {
  case loading, loaded, failed
}

final class SummaryViewModel: ObservableObject {
  // MARK: - Internal Variable
  private let record: RecordDetailVO
  private let memos: [MemoVO]
  private let quotes: [QuoteVO]
  
  // MARK: - State
  @Published var dataState: SummaryState = .loading
  @Published var summary: SummaryVO?
  @Published var memoData: [String] = []
  @Published var quoteData: [String] = []
  
  // MARK: - Dependency
  @Dependency
  private var summaryUseCase: SummaryUseCase
  
  init(record: RecordDetailVO, memos: [MemoVO], quotes: [QuoteVO]) {
    self.record = record
    self.memos = memos
    self.quotes = quotes
    
    memoData = memos.map { $0.content }
    quoteData = quotes.map { $0.content }
    
    // 요약 생성
  }
  
  enum Action {
    case onAppear
    case generateSummary
    case saveSummary
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
    case .generateSummary:
    case .saveSummary:
    }
  }
  
}

// MARK: - Internal Function
private extension SummaryViewModel {
  func generateSummary(recordVO: RecordDetailVO) {
    Task{
      do {
        let recordData = recordVO.toEntity(memos: memos, quotes: quotes)
        let summaryData = try await summaryUseCase.generateSummary(in: recordData)
        
        await MainActor.run {
          summary = SummaryVO(summaryData)
          dataState = .loaded
        }
      } catch {
        print(error)
        await MainActor.run {
          dataState = .failed
        }
      }
      
    }
  }
  
  
  
}
