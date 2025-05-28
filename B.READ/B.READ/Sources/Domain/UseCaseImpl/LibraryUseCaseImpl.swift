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
    try await bookRepository.createBook(book)
    try await recordRepository.createRecord(record)
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
    try await withThrowingTaskGroup(of: Void.self) {
      [weak self] group in
      guard let self = self else { return }
      
      // 1. 요약노트 삭제
      
      if let noteID = record.summaryID {
        group.addTask {
//          do {
//            try await noteRepository.deleteNote(id: noteID)
//          } catch {
//            print("ERROR: Note Delete Fail")
//          }
        }
      }
      
      // 2. 문장 삭제
      for quoteID in record.quoteIDs {
        group.addTask {
          do {
            try await self.quoteRepository.deleteQuote(id: quoteID)
          } catch {
            print("ERROR: Quote Delete Fail")
          }
        }
      }
      
      // 3. 메모 삭제
      for memoID in record.memoIDs {
        group.addTask {
//          do {
//            try await memoRepository.deleteMemo(id: memoID)
//          } catch {
//            print("ERROR: Memo Delete Fail")
//          }
        }
      }
      
      // group의 작업이 종료 되길 기다림
      for try await _ in group { }
    }
    // 4. 독서 기록 삭제
    try await recordRepository.deleteRecord(record.id)
  }
  
  
  func loadRecord(_ recordID: String) async throws -> (Record, Book) {
    
    let record = try await recordRepository.fetchRecord(id: recordID)
    let book = try await bookRepository.fetchBook(isbn: record.isbn)
    
    return (record, book)
  }
  
  
  func loadRecordList() async throws -> [(Record, Book)] {
    let cellInfos: [(Record, Book)]
    
    // 1. 독서 기록 정보 패치
    let records = try await recordRepository.fetchAllRecord()
    
    // 2. 태스크 그룹으로 정보를 가져옴
    cellInfos = try await withThrowingTaskGroup(of: (Record, Book)?.self) {
      [weak self] group in
      guard let self = self else { return [] }
      
      for record in records {
        // 3. record 기준으로 각각의 책정보 가져오는 걸 자식 태스크로 지정
        group.addTask {
          do {
            let book = try await self.bookRepository.fetchBook(isbn: record.isbn)
            return (record, book)
          } catch {
            // TODO: - RepositoryError.dataNotFound이면 알라딘에서 책검색, 아니면 nil
            print(error.localizedDescription)
            return nil
          }
        }
      }
      
      var results: [(Record, Book)] = []
      // 4. 태스크 그룹의 결과를 results에 저장
      for try await result in group {
        if let info = result {
          results.append(info)
        }
      }
      
      return results
    }
    // 5. 최종적인 [(독서기록, 책)]을 반환
    return cellInfos
  }
  
  // TODO: - 몽피
  func loadRecentUpdatedReadingRecord(maxCount: Int) async throws -> [(Record, Book)] {
    return []
  }
}
