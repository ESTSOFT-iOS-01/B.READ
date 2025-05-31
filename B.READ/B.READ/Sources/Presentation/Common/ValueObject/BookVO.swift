//
//  BookVO.swift
//  B.READ
//
//  Created by 심근웅 on 5/31/25.
//

import Foundation
import SwiftUI

struct BookVO: Identifiable {
  let id: String
  let isbn: String
  let coverImage: Image
  let title: String
  let author: String
  let publisher: String
  let publishedDate: Date
}
