//
//  BookServiceTest.swift
//  B.READTests
//
//  Created by 김도연 on 5/23/25.
//

import Foundation
import Testing

@testable import B_READ

struct BookServiceTest {
  
//  @Test("Success fetchBookList()")
//  func testFetchBookListDecoding() async throws {
//    let mockClient = MockNetworkClient(nextMockFileName: "SearchList")
//    let aladinService = AladinService(client: mockClient)
//    
//    // when
//    let result = try await aladinService.fetchBookList(for: "데미안", index: 1)
//    
//    // then
//    #expect(result.totalCount == 352)
//    #expect(result.books.count > 0)
//    
//    // 디코딩된 첫 번째 책 정보 출력
//    if let first = result.books.first {
//      print("Title: \(first.title)")
//      print("Author: \(first.author)")
//      print("ISBN: \(first.isbn)")
//    }
//  }
  
//  @Test("Success testFetchBookDetailDecoding()")
//  func testFetchBookDetailDecoding() async throws {
//    let mockClient = MockNetworkClient(nextMockFileName: "Book")
//    let aladinService = AladinService(client: mockClient)
//    
//    // when
//    let detail = try await aladinService.fetchBookDetail(isbn: "9791187011590")
//    
//    // then
//    #expect(detail.title.contains("데미안"))
//    #expect(detail.author.contains("헤르만 헤세"))
//    #expect(detail.ratingScore == 9.6)
//    #expect(detail.pageCount == 220)
//
//    print("Book Detail:")
//    print("Title: \(detail.title)")
//    print("Author: \(detail.author)")
//    print("Publisher: \(detail.publisher)")
//    print("Page: \(detail.pageCount) pages")
//    print("Rating: \(detail.ratingScore) (\(detail.ratingCount) reviews)")
//  }

//  @Test("Success testFetchBestSellerDecoding()")
//  func testFetchBestSellerDecoding() async throws {
//    let mockClient = MockNetworkClient(nextMockFileName: "BestSeller")
//    let aladinService = AladinService(client: mockClient)
//    
//    // when
//    let result = try await aladinService.fetchBestSeller(in: 0)
//
//    // then
//    #expect(result.count > 0)
//    #expect(result[0].title.contains("청춘의 독서"))
//    #expect(result[0].rank == 1)
//
//    print("Bestseller List (Top 3):")
//    for book in result.prefix(3) {
//      print("- \(book.rank)위: \(book.title) by \(book.author)")
//    }
//  }
  
//  @Test("Success testFetchBestSellerDecoding() - Select Category")
//  func testFetchBestSellerInCookingCategory() async throws {
//    let mockClient = MockNetworkClient(nextMockFileName: "CategoryBest")
//    let aladinService = AladinService(client: mockClient)
//
//    // when
//    let result = try await aladinService.fetchBestSeller(in: 1230)
//
//    // then
//    #expect(result.count == 10)
//    #expect(result[0].title.contains("스위치온"))
//    #expect(result[0].rank == 1)
//
//    print("🥘 Cooking Bestseller List (Top 3):")
//    for book in result.prefix(3) {
//      print("- \(book.rank)위: \(book.title) by \(book.author)")
//    }
//  }

//  @Test("Error: Missing Query")
//  func testMissingQueryErrorDecoding() async throws {
//    let mockClient = MockNetworkClient(
//      nextMockFileName: "MissingQuery",
//      shouldReturnError: false
//    )
//    let aladinService = AladinService(client: mockClient)
//
//    do {
//      _ = try await aladinService.fetchBookList(for: "", index: 1)
//      #expect(false)
//    } catch let error as AladinError {
//      switch error {
//      case .serverError(let code, let message):
//        #expect(code == 3)
//        #expect(message == "검색어를 입력해주세요.")
//        print("✅ Correctly decoded Aladin error: [\(code)] \(message)")
//      default:
//        print("Expected serverError, but got \(error)")
//        #expect(false)
//      }
//    } catch {
//      print("Unexpected error type: \(error)")
//      #expect(false)
//    }
//  }

}
