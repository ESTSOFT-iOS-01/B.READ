//
//  LibraryUseCaseImpl.swift
//  B.READ
//
//  Created by 심근웅 on 5/26/25.
//

import Foundation

final class LibraryUseCaseImpl: LibraryUseCase {
  
  private let bookRepository: BookRepository
  private let recordRepository: RecordRepository
  //  private let memoRepository: MemoRepository
  private let quoteRepository: QuoteRepository
  //  private let noteRepository: NoteRepository
  
  init(
    bookRepository: BookRepository,
    recordRepository: RecordRepository,
    quoteRepository: QuoteRepository
  ) {
    self.bookRepository = bookRepository
    self.recordRepository = recordRepository
    self.quoteRepository = quoteRepository
  }
  
  // TODO: - 도로시
  func saveRecord(record: Record, book: Book) async throws {
    
  }
  
  
  func editRecord(_ record: Record) async throws {
    do {
      // 1. 독서 기록을 수정
      try await recordRepository.updateRecord(record)
    } catch RepositoryError.dataNotFound {
      // 2. 책은 존재하는지 확인
      do {
        let _ = try await bookRepository.fetchBook(isbn: record.isbn)
      } catch RepositoryError.dataNotFound {
        // TODO: - 2-1. 책도 없으면 알라딘에서 검색해서 생성
      }
      // 1-1. 데이터가 없는 경우, 데이터 새로 생성
      try await recordRepository.createRecord(record)
    }
  }
  
  
  func deleteRecord(_ record: Record) async throws {
    // MARK: - 부모 테스크: await (요약,메모,문장 삭제) await 독서 기록 삭제
    // TODO: - 테스크 그룹으로 돌리는데 각각 발생한 문제는 어떻게 처리할지?
    // - 중간하나에서 패치 실패가 나오면 그래도 나머지는 실행해야하지않나?
    
    
    // 1. 요약노트 삭제
//    if let noteID = record.summaryID {
//      try await noteRepository.deleteNote(id: noteID)
//    }
    
    // 2. 문장 삭제
    // TODO: - 태스크 그룹으로 삭제(비동기)
    for quoteID in record.quoteIDs {
      try await quoteRepository.deleteQuote(id: quoteID)
    }
    
    // 3. 메모 삭제
    // TODO: - 태스크 그룹으로 삭제(비동기)
//    for memoID in record.memoIDs {
//      try await quoteRepository.deleteMemo(id: memoID)
//    }
    
    // 4. 독서 기록 삭제
    try await recordRepository.deleteRecord(record.id)
  }
  
  
  func loadRecord(_ recordID: String) async throws -> (Record, Book) {
    // TODO: - 태스크 그룹으로 독서 기록, 책 정보 비동기로 받아옴
    
    let record = try await recordRepository.fetchRecord(id: recordID)
    let book = try await bookRepository.fetchBook(isbn: record.isbn)
    
    return (record, book)
  }
  
  
  func loadRecordList() async throws -> [(Record, Book)] {
    var cellInfos: [(Record, Book)] = []
    
    // 1. 독서 기록 정보 패치
    let records = try await recordRepository.fetchAllRecord()
    
    // 2. 독서 기록에 대한 도서 정보 패치
    // TODO: - 태스크 그룹으로 독서 기록에 대한 도서 정보 비동기로 받아옴
    for record in records {
      let book = try await bookRepository.fetchBook(isbn: record.isbn)
      // 정보를 infos에 저장
      cellInfos.append((record, book))
    }
    return cellInfos
  }
  
  
  // TODO: - 몽피
  func loadRecentUpdatedReadingRecord(maxCount: Int) async throws -> [(Record, Book)] {
    return []
  }
}
