//
//  AladinService.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import Foundation

final class AladinService: BookService {
  
  private let client = NetworkClient.shared
  
  func fetchBookList(for keyword: String, index pageIndex: Int = 1) async throws -> SearchPagnation {
    print("Impl: ", #function)
    
    let dto = try await client.performOrDecodeAladinError(
      AladinRouter.getBookList(query: keyword),
      decodeType: SearchListDTO.self)
    
    return SearchPagnation(
      totalCount: dto.totalCount,
      startIndex: dto.startIndex,
      countPerPage: dto.countPerPage,
      books: dto.books.map {
        BookPreview(
          title: $0.title,
          author: $0.author,
          publishedDate: $0.publishedDate,
          description: $0.description,
          isbn: $0.isbn,
          coverURL: $0.coverURL,
          publisher: $0.publisher
        )
      }
    )
  }

  func fetchBookDetail(isbn: String) async throws -> BookDetail {
    print("Impl: ", #function)
    
    let dto = try await client.performOrDecodeAladinError(
      AladinRouter.getBook(isbn: isbn),
      decodeType: SearchDTO.self)
    
    guard let book = dto.item.first else {
      throw AladinError.decodingError(message: "책 정보를 찾을 수 없습니다.")
    }
    
    return BookDetail(
      title: book.title,
      author: book.author,
      publishedDate: book.publishedDate,
      description: book.description,
      isbn: book.isbn,
      coverURL: book.coverURL,
      publisher: book.publisher,
      pageCount: book.pageCount,
      ratingScore: book.ratingScore,
      ratingCount: book.ratingCount
    )
    
  }

  func fetchBestSeller(in category: Int = 0) async throws -> [BestSeller] {
    print("Impl: ", #function)
    
    let dto = try await client.performOrDecodeAladinError(
      AladinRouter.getBestSellerList(categoryID: category),
      decodeType: BestSellerListDTO.self)
    
    return dto.item.map{
      BestSeller(
        title: $0.title,
        author: $0.author,
        isbn: $0.isbn,
        coverURL: $0.coverURL,
        rank: $0.rank)
    }
  }
}
