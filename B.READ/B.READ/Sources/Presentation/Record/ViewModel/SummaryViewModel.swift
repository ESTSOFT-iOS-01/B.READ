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
  let record: RecordDetailVO
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
  
  // MARK: - Init
  // 버튼을 통해 생성 페이지로 넘어왔을 때,
  init(record: RecordDetailVO, memos: [MemoVO], quotes: [QuoteVO]) {
    self.record = record
    self.memos = memos
    self.quotes = quotes
    
    memoData = memos.map { $0.content }
    quoteData = quotes.map { $0.content }
    
    generateSummary()
  }
  
  // 이미 만들어진 요약노트를 조회할 때,
  init(id: String, record: RecordDetailVO, memos: [MemoVO], quotes: [QuoteVO]) {
    self.record = record
    self.memos = memos
    self.quotes = quotes
    
    memoData = memos.map { $0.content }
    quoteData = quotes.map { $0.content }
    
    fetchSummary(id)
  }
  
}

private extension SummaryViewModel {
  func generateSummary() {
    Task{
      do {
        let recordData = record.toEntity(memos: memos, quotes: quotes)
        let summaryData = try await summaryUseCase.generateSummary(in: recordData)
        try await summaryUseCase.saveSummary(summaryData, in: recordData)
        
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
  
  func fetchSummary(_ id: String) {
    Task {
      do {
        let summaryData = try await summaryUseCase.fetchSummary(id: id)
        
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
