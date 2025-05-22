//
//  ScanViewModel.swift
//  B.READ
//
//  Created by 김도연 on 5/22/25.
//

import Foundation
import SwiftUI

final class ScanViewModel: ObservableObject {
  var coordinator: SearchCoordinator
  
  @Published var noCamera: Bool = false
  @Published var isbnNumber: String = ""
  
  init(coordinator: SearchCoordinator) {
    self.coordinator = coordinator
  }
}
