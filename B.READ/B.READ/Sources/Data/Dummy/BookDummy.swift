//
//  BookDummy.swift
//  B.READ
//
//  Created by 심근웅 on 5/18/25.
//

import Foundation

// MARK: - Book Entity
// TODO: - Entity 머지 되면 해당 Entity 삭제
/// 도서 정보입니다.
/// - isbn : ISBN
/// - coverImg : 표지
/// - name : 제목
/// - author : 작가 // TODO : 번역가, 옮김이 포함되는지 확인 필요
/// - publisher : 출판사
/// - publishedAt : 출판일
/// - totalPages: 총 페이지
struct Book {
  let isbn: String
  var coverImg: Data?
  let name: String
  let author: String
  let publisher: String
  let publishedAt: Date
  let totalPages: Int
}


