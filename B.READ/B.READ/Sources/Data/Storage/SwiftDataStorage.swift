//
//  SwiftDataStorage.swift
//  B.READ
//
//  Created by 신승재 on 5/18/25.
//

import Foundation
import SwiftData

final class SwiftDataStorage {
  let modelContainer = {
    let schema = Schema(
      [UserInfoDTO.self,
       QuoteDTO.self]
    )
    let configuration = ModelConfiguration(
      isStoredInMemoryOnly: false
    )
    
    do {
      let container = try ModelContainer(
        for: schema,
        configurations: configuration
      )
      return container
    } catch {
      fatalError("Model Container error")
    }
  }()
}
