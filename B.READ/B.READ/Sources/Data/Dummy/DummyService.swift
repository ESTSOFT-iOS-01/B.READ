//
//  DummyService.swift
//  B.READ
//
//  Created by 심근웅 on 5/28/25.
//

import Foundation

final class DummyService {
  static let shared: DummyService = DummyService()
  
  
  @Dependency private var libUseCase: LibraryUseCase
  @Dependency private var quoteUseCase: QuoteUseCase
  
  func setDummy() async {
    // 1. 독서 기록, 도서 더미정보 저장
    for record in DummyData.dummyRecords {
      if let book = DummyData.dummyBooks.filter({ $0.isbn == record.isbn }).first {
        try? await libUseCase.saveRecord(record: record, book: book)
      }
    }
    
    // 2. 문장 더미 정보 저장
    for quote in DummyData.dummyQuote {
      try? await quoteUseCase.addQuote(quote)
    }
    
    // 3. 메모 더미 정보 저장
    
  }
}
