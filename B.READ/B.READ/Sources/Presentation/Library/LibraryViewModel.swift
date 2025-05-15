//
//  LibraryViewModel.swift
//  B.READ
//
//  Created by 심근웅 on 5/15/25.
//

import Foundation
import SwiftUI

final class LibraryViewModel: ObservableObject {
  
  // MARK: - State
  @Published var datas: [Data] = []
  
  // MARK: - Internal Variable
  private var example: String?
  
  // MARK: - Dependency
//  @Dependency private var exampleUseCase: ExampleUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      reset()
    }
  }
}

// MARK: - Internal Function
private extension ExampleViewModel {
  func initialize() {
    Task {
      do {
        let datas = try await exampleUseCase.fetchDatas()
        // UI 상태를 변경할 시에는 명시적으로 작성해줍니다.
        // 또한 변수에 할당 시 self 명시해줍니다.(함수는 X)
        await MainActor.run { self.datas = datas }
      } catch {
        print(error)
      }
    }
  }
}
