//
//  HomeViewModel.swift
//  B.READ
//
//  Created by 신승재 on 5/29/25.
//

import Foundation

final class HomeViewModel: ObservableObject {
  
  // MARK: - State
  @Published var recentRecords: [RecordVO] = []
  
  // MARK: - Internal Variable
  private var example: String?
  
  // MARK: - Dependency
  @Dependency
  private var libraryUseCase: LibraryUseCase
  
  init() {
    //print("HomeViewModel 생성")
  }
  
  // MARK: - Action
  enum Action {
    case onAppear
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      print("onAppear")
    }
  }
  
  deinit {
    print("HomeViewModel 소멸")
  }
}

// MARK: - Internal Function
private extension SettingViewModel {
  
}

