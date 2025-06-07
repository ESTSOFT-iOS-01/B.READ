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
  @Dependency private var memoUseCase: MemoUseCase
  
  public func setDummy() async {
    // 1. 독서 기록, 도서 더미정보 저장
    for record in DummyData.dummyRecords {
      if let book = DummyData.dummyBooks.filter({ $0.isbn == record.isbn }).first {
        do {
          try await libUseCase.saveRecord(record: record, book: book)
        } catch {
          print(error.localizedDescription)
        }
        
      }
    }
    // 2. 문장 더미 정보 저장
    for quote in DummyData.dummyQuote {
      for record in DummyData.dummyRecords {
        if record.isbn == quote.isbn {
          try? await quoteUseCase.addQuote(quote, in: record)
          break
        }
      }
    }
    
    // 3. 메모 더미 정보 저장
    for memo in DummyData.dummyMemos {
      for record in DummyData.dummyRecords {
        if record.isbn == memo.isbn {
          try? await memoUseCase.saveMemo(memo, in: record)
          break
        }
      }
    }
    
  }
}
