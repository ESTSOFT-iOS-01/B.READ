//
//  SearchVOModel.swift
//  B.READ
//
//  Created by 김도연 on 5/18/25.
//

import SwiftUI

struct BookVO {
  let isbn: String
  let coverImage: Image
  let title: String
  let author: String
  let publisher: String
  let publishedDate: Date
}

struct RecordVO {
  let isbn: String
  let coverImage: Image
  let id: String
  let title: String
  
}
