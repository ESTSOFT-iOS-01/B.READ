//
//  BookRepositoryTest.swift
//  B.READTests
//
//  Created by 심근웅 on 5/20/25.
//

import Foundation
import Testing

struct BookRepositoryTest {
  
  private let bookRepository: BookRepository
  
  init() {
    bookRepository = BookRepositoryStub()
//    let storage = SwiftDataTestStorage()
//    bookRepository = BookRepositoryImpl(modelContainer: storage.modelContainer)
  }
  
  @Test("Book Create Test")
  func createBook() async throws {
    let isbn = "9791194368137"
    try await bookRepository.createBook(DummyData.books[0])
    let book = try await bookRepository.fetchBook(isbn: isbn)
    
    #expect(book == DummyData.books[0])
  }
  
  @Test("Book Create Error Test - Data Already Exists")
  func createBookDataAlreadyExist() async throws {
    try await bookRepository.createBook(DummyData.books[0])
    
    await #expect(throws: RepositoryError.dataAlreadyExist, performing: {
      try await bookRepository.createBook(DummyData.books[0])
    })
  }
  
  @Test("Book Fetch Error Test - Data Not Found")
  func fetchBookDataNotFound() async throws {
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await bookRepository.fetchBook(isbn: "1111")
    })
  }
  
  @Test("Book All Update Test")
  func updateBookAll() async throws {
    let basicBook = DummyData.books[0]
    let updateBook = DummyData.books[1]
    try await bookRepository.createBook(basicBook)
    
    // isbn만 0번 도서이고, 내용은 1번 도서로 바꿈
    let updatedBook = Book(
      isbn: basicBook.isbn,
      name: updateBook.name,
      author: updateBook.author,
      publisher: updateBook.publisher,
      publishedAt: updateBook.publishedAt,
      totalPages: updateBook.totalPages
    )
    
    try await bookRepository.updateBook(updatedBook)
    
    let fetchBook = try await bookRepository.fetchBook(isbn: basicBook.isbn)
    
    #expect(updatedBook == fetchBook)
  }
  
  @Test("Book Partial Update Test - CoverImage, TotalPage")
  func updatePartialBookCoverImage() async throws {
    // 처음데이터, 생성 후 값 변경이 이루어짐
    var currentBook = DummyData.books[0]
    let coverImageData = Data(count: 10)
    
    // 최종적으로 DB에 저장될 형태
    let updatedBook = Book(
      isbn: currentBook.isbn,
      coverImage: coverImageData,
      name: currentBook.name,
      author: currentBook.author,
      publisher: currentBook.publisher,
      publishedAt: currentBook.publishedAt,
      totalPages: currentBook.totalPages + 10
    )
    try await bookRepository.createBook(currentBook)
    
    currentBook.coverImage = coverImageData
    currentBook.totalPages += 10
    
    try await bookRepository.updateBook(currentBook)
    let fetchBook = try await bookRepository.fetchBook(isbn: currentBook.isbn)
    
    #expect(fetchBook == updatedBook)
  }
  
  @Test("Book Update Error Test - Data Not Found")
  func updateBookDataNotFound() async throws {
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await bookRepository.updateBook(DummyData.books[0])
    })
  }
}
