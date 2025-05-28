//
//  AladinResponse.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import Foundation

// 상품 검색 API
struct SearchListDTO: Decodable {
  let totalCount: Int
  let startIndex: Int
  let countPerPage: Int
  let books: [ItemPreviewDTO]
  
  enum CodingKeys: String, CodingKey {
    case totalCount = "totalResults"
    case startIndex
    case countPerPage = "itemsPerPage"
    case books = "item"
  }
}

extension SearchListDTO {
  func toEntity() -> SearchPagnation {
    return SearchPagnation(
      totalCount: totalCount,
      startIndex: startIndex,
      countPerPage: countPerPage,
      books: books.map { $0.toEntity() }
    )
  }
}

struct ItemPreviewDTO: Decodable {
  let title: String
  let author: String
  let publishedDate: String
  let description: String
  let isbn: String
  let coverURL: String
  let publisher: String
  
  enum CodingKeys: String, CodingKey {
    case title, author, description, publisher
    case publishedDate = "pubDate"
    case isbn = "isbn13"
    case coverURL = "cover"
  }
}

extension ItemPreviewDTO {
  func toEntity() -> BookPreview {
    return BookPreview(
      title: title,
      author: author,
      publishedDate: publishedDate,
      description: description,
      isbn: isbn,
      coverURL: coverURL,
      publisher: publisher
    )
  }
}

// 상품 조회 API
struct SearchDTO: Decodable {
  let item: [ItemDTO]
}

struct ItemDTO: Decodable {
  let title: String
  let author: String
  let publishedDate: String
  let description: String
  let isbn: String
  let coverURL: String
  let publisher: String
  let pageCount: Int
  let ratingScore: Double
  let ratingCount : Int
  let aladinLink : String
  
  enum CodingKeys: String, CodingKey {
    case title, author, description, publisher
    case publishedDate = "pubDate"
    case isbn = "isbn13"
    case coverURL = "cover"
    case aladinLink = "link"
    case subInfo
  }
  
  enum SubInfoKeys: String, CodingKey {
    case itemPage
    case ratingInfo
  }
  
  enum RatingInfoKeys: String, CodingKey {
    case ratingScore
    case ratingCount
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.title = try container.decode(String.self, forKey: .title)
    self.author = try container.decode(String.self, forKey: .author)
    self.publishedDate = try container.decode(String.self, forKey: .publishedDate)
    self.description = try container.decode(String.self, forKey: .description)
    self.isbn = try container.decode(String.self, forKey: .isbn)
    self.coverURL = try container.decode(String.self, forKey: .coverURL)
    self.aladinLink = try container.decode(String.self, forKey: .aladinLink)
    self.publisher = try container.decode(String.self, forKey: .publisher)
    
    let subInfo = try container.nestedContainer(keyedBy: SubInfoKeys.self, forKey: .subInfo)
    self.pageCount = try subInfo.decode(Int.self, forKey: .itemPage)
    
    let ratingInfo = try subInfo.nestedContainer(keyedBy: RatingInfoKeys.self, forKey: .ratingInfo)
    self.ratingScore = try ratingInfo.decode(Double.self, forKey: .ratingScore)
    self.ratingCount = try ratingInfo.decode(Int.self, forKey: .ratingCount)
  }
}

extension ItemDTO {
  func toEntity() -> BookDetail {
    return BookDetail(
      title: title,
      author: author,
      publishedDate: publishedDate,
      description: description,
      isbn: isbn,
      coverURL: coverURL,
      publisher: publisher,
      pageCount: pageCount,
      ratingScore: ratingScore,
      ratingCount: ratingCount,
      link: aladinLink
    )
  }
}

// 베스트셀러 API
struct BestSellerListDTO: Decodable {
  let item: [BestSellerDTO]
}

struct BestSellerDTO: Decodable {
  let title: String
  let author: String
  let isbn: String
  let coverURL: String
  let rank: Int
  
  enum CodingKeys: String, CodingKey {
    case title, author
    case isbn = "isbn13"
    case coverURL = "cover"
    case rank = "bestRank"
  }
}

extension BestSellerDTO {
  func toEntity() -> BestSeller {
    return BestSeller(
      title: title,
      author: author,
      isbn: isbn,
      coverURL: coverURL,
      rank: rank
    )
  }
}

// 공통 Error DTO
struct AladinErrorDTO: Decodable {
  let errorCode: Int
  let errorMessage: String
}
