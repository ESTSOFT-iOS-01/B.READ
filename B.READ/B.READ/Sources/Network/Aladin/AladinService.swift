//
//  AladinService.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import Foundation

public final class AladinService: BookService {
  
  private let client: NetworkClient
  
  init(client: NetworkClient = .shared) {
    self.client = client
  }
  
  func fetchBookList(for keyword: String, index pageIndex: Int = 1) async throws -> SearchPagnation {
    print("Impl: ", #function)
    
    let dto = try await client.performOrDecodeAladinError(
      AladinRouter.getBookList(query: keyword),
      decodeType: SearchListDTO.self)

    return dto.toEntity()
  }

  func fetchBookDetail(isbn: String) async throws -> BookDetail {
    print("Impl: ", #function)
    
    let dto = try await client.performOrDecodeAladinError(
      AladinRouter.getBook(isbn: isbn),
      decodeType: SearchDTO.self)
    
    guard let book = dto.item.first else {
      throw AladinError.decodingError(message: "책 정보를 찾을 수 없습니다.")
    }
    
    return book.toEntity()
    
  }

  func fetchBestSeller(in category: Int = 0) async throws -> [BestSeller] {
    print("Impl: ", #function)
    
    let dto = try await client.performOrDecodeAladinError(
      AladinRouter.getBestSellerList(categoryID: category),
      decodeType: BestSellerListDTO.self)
    
    return dto.item.map{ $0.toEntity() }
  }
}
