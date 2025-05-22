//
//  BookViewModel.swift
//  B.READ
//
//  Created by 김도연 on 5/22/25.
//

import Foundation
import SwiftUI

final class BookViewModel: ObservableObject {
  var coordinator: SearchCoordinator
  var isbn: String
  
  @Published var text: String = "BookDetailView입니다. 아직 아무것도 없습니다."
  
  init(coordinator: SearchCoordinator, isbn: String) {
    self.coordinator = coordinator
    self.isbn = isbn
    print("BookViewModel \(ObjectIdentifier(coordinator))")
  }
  
}
