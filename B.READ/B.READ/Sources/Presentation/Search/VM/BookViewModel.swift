//
//  BookViewModel.swift
//  B.READ
//
//  Created by 김도연 on 5/22/25.
//

import Foundation
import SwiftUI

final class BookViewModel: ObservableObject {
  var isbn: String
  
  @Published var text: String = "BookDetailView입니다. 아직 아무것도 없습니다."
  
  init(isbn: String) {
    self.isbn = isbn
  }
  
  
  
}
