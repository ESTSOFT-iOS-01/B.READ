//
//  SwiftDataTestStorage.swift
//  B.READTests
//
//  Created by 신승재 on 5/18/25.
//

import Foundation
import SwiftData

final class SwiftDataTestStorage {
  let modelContainer = {
    let schema = Schema(
      [UserInfoDTO.self]
    )
    let configuration = ModelConfiguration(
      isStoredInMemoryOnly: true
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
