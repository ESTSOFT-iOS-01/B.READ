//
//  LibraryUseCaseImpl.swift
//  B.READ
//
//  Created by 심근웅 on 5/26/25.
//

import Foundation

final class LibraryUseCaseImpl: LibraryUseCase {
  
  private let userInfoRepository: UserInfoRepository
  private let bookRepository: BookRepository
  private let recordRepository: RecordRepository
  //  private let memoRepository: MemoRepository
  private let quoteRepository: QuoteRepository
  //  private let noteRepository: NoteRepository
  private let bookService: BookService
  
  init(
    userInfoRepository: UserInfoRepository,
    bookRepository: BookRepository,
    recordRepository: RecordRepository,
    quoteRepository: QuoteRepository,
    bookService: BookService
  ) {
    self.userInfoRepository = userInfoRepository
    self.bookRepository = bookRepository
    self.recordRepository = recordRepository
    self.quoteRepository = quoteRepository
    self.bookService = bookService
  }
  
  func saveRecord(record: Record, book: Book) async throws {
    do {
      try await bookRepository.createBook(book)
    } catch RepositoryError.dataAlreadyExist {
      // 이미 존재하면 무시
      print("이미 존재하는 책입니다.")
    }
    
    try await recordRepository.createRecord(record)
  }
  
  func editRecord(_ record: Record) async throws {
    do {
      // 1. 책이 있는지 부터 확인
      let _ = try await bookRepository.fetchBook(isbn: record.isbn)
    } catch RepositoryError.dataNotFound{
      // 2. 책이 없으면 책 생성
      let requestBook = try await requestBookDetail(isbn: record.isbn)
      try await bookRepository.createBook(requestBook)
    }
    
    do {
      // 3. 독서 기록을 수정
      try await recordRepository.updateRecord(record)
    } catch RepositoryError.dataNotFound{
      // 4. 독서 기록이 없으면 생성
      try await recordRepository.createRecord(record)
    }
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
  
  func deleteRecord(_ record: Record) async throws {
    try await recordRepository.deleteRecord(record.id)
  }
  
  func loadRecentUpdatedReadingRecord(maxCount: Int) async throws -> [(Record, Book)] {
    // 1. 최근 읽은 기록을 최대 maxCount개까지 가져온다
    let records = try await recordRepository.fetchRecentReadingRecord(maxCount: maxCount)
    
    // 2. 중복 제거된 ISBN 목록을 추출한다
    let isbns = Set(records.map { $0.isbn })
    
    // 3. ISBN에 해당하는 책 정보를 미리 조회하여 딕셔너리에 저장한다
    var books: [String: Book] = [:]
    for isbn in isbns {
      let book = try await bookRepository.fetchBook(isbn: isbn)
      books[isbn] = book
    }
    
    // 4. 레코드와 대응하는 책 정보를 매칭하여 (Record, Book) 튜플을 생성한다
    var pairsItems: [(Record, Book)] = []
    for record in records {
      if let book = books[record.isbn] {
        // 4-1. 딕셔너리에 있는 책 정보를 사용
        pairsItems.append((record, book))
      } else {
        // 4-2. 책 정보가 없을 경우 외부 API를 통해 요청하여 가져옴
        let requestBook = try await requestBookDetail(isbn: record.isbn)
        pairsItems.append((record, requestBook))
      }
    }
    
    // 5. 최종적으로 (Record, Book) 쌍을 반환
    return pairsItems
  }
}

private extension LibraryUseCaseImpl {
  func requestBookDetail(isbn: String) async throws -> Book {
    let bookDetail = try await bookService.fetchBookDetail(isbn: isbn)
    // NOTE: 생각해보니 DTO -> Entity로 가는 로직이 필요할 것 같네요(Sprint2)
    let book = Book(
      isbn: bookDetail.isbn,
      coverImage: nil, // TODO: 이미지 처리
      name: bookDetail.title,
      author: bookDetail.author,
      publisher: bookDetail.publisher,
      publishedAt: .now, // TODO: Date 처리
      totalPages: bookDetail.pageCount
    )
    try await bookRepository.createBook(book)
    return book
  }
}
