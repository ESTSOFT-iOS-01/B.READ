//
//  SettingViewModel.swift
//  B.READ
//
//  Created by 신승재 on 5/22/25.
//

import Foundation

final class SettingViewModel: ObservableObject {
  
  // MARK: - State
  @Published var datas: [Data] = []
  
  // MARK: - Internal Variable
  private var example: String?
  
  // MARK: - Dependency
  // TODO: UseCase 교체
  private var profileUseCase = ProfileUseCaseImpl(userInfoRepository: UserInfoRepositoryStub())
  
  // MARK: - Action
  enum Action {
    case saveNickname
    case saveCatetories
  }
  
  func send(_ action: Action) {
    switch action {
    case .saveNickname:
      print(#function)
    case .saveCatetories:
      print(#function)
    }
  }
}

// MARK: - Internal Function
private extension SettingViewModel {
  func saveNickName() async {
    Task {
      
    }
  }
}
// 48
