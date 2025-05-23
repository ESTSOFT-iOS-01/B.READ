//
//  AladinRouter.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import Foundation

enum AladinRouter: RequestConvertible {
  
  case getBookList(query: String)
  case getBook(isbn: String)
  case getBestSellerList(categoryID: Int = 0)
  
  // MARK: - BaseURL
  private var baseURL: URL {
    AladinAPI.baseURL
  }
  
  // MARK: - Path
  private var path: String {
    switch self {
    case .getBookList(_):
      "/ItemSearch.aspx?"
    case .getBook(_):
      "/ItemLookUp.aspx?"
    case .getBestSellerList(_):
      "/ItemList.aspx?"
    }
  }
  
  // MARK: - Method
  private var method: HTTPMethod {
    switch self {
    default:
        .get
    }
  }
  
  
  // MARK: - QueryItems
  private var queryItems: [URLQueryItem]? {
    var queryItems: [URLQueryItem] = [
      URLQueryItem(name: "ttbkey", value: AladinAPI.ttbKey),
      URLQueryItem(name: "output", value: "JS"),
      URLQueryItem(name: "Version", value: "20131101"),
  ]
    
    switch self {
    case .getBookList(let query):
      var bookListQueryItems = queryItems + [
        URLQueryItem(name: "Query", value: query)
      ]
      return bookListQueryItems
    case .getBook(let isbn):
      var bookQueryItems = queryItems + [
        URLQueryItem(name: "ItemIdType", value: "ISBN"),
        URLQueryItem(name: "ItemId", value: isbn),
        URLQueryItem(name: "OptResult", value: "ratingInfo")
      ]
      return bookQueryItems
    case .getBestSellerList(let categoryID):
      var bestSellerQueryItems = queryItems + [
        URLQueryItem(name: "QueryType", value: "Bestseller"),
        URLQueryItem(name: "SearchTarget", value: "Book"),
        URLQueryItem(name: "CategoryId", value: "\(categoryID)")
      ]
      return bestSellerQueryItems
    }
  }
  
  // MARK: - asURLRequest
  func asURLRequest() throws -> URLRequest {
    
    var components = URLComponents(
      url: baseURL.appendingPathComponent(path),
      resolvingAgainstBaseURL: false
    )!
    components.queryItems = queryItems
    
    var request = URLRequest(url: components.url!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.method = method
    
    return request
  }
}
