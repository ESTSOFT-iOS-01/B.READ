//
//  ScanViewModel.swift
//  B.READ
//
//  Created by 김도연 on 5/22/25.
//

import Foundation
import SwiftUI

final class ScanViewModel: ObservableObject {
  @Published var noCamera: Bool = false
  @Published var isbnNumber: String = ""
  
  init() {
    self.noCamera = false
    self.isbnNumber = ""
  }
}
