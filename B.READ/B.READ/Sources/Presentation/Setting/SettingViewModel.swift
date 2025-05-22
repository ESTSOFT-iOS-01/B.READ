//
//  SettingViewModel.swift
//  B.READ
//
//  Created by 신승재 on 5/22/25.
//

import Foundation

final class SettingViewModel: ObservableObject {
  
  // MARK: - State
  @Published var userInfo: UserInfo? = nil
  
  // MARK: - Internal Variable
  private var example: String?
  
  // MARK: - Dependency
  // TODO: UseCase 교체
  private var profileUseCase = ProfileUseCaseImpl(userInfoRepository: UserInfoRepositoryStub())
  
  init() {
    fetchUserInfo()
  }
  
  // MARK: - Action
  enum Action {
    case saveNickname(String)
    case saveCatetories([CategoryType])
  }
  
  func send(_ action: Action) {
    switch action {
    case .saveNickname(let nickname):
      Task {
        do {
          try await profileUseCase.setNickname(nickname)
        } catch {
          print(error.localizedDescription)
        }
      }
    case .saveCatetories(let categories):
      Task {
        do {
          try await profileUseCase.setCategory(categories)
        } catch {
          print(error.localizedDescription)
        }
      }
    }
  }
}

// MARK: - Internal Function
private extension SettingViewModel {
  func fetchUserInfo() {
    Task {
      do {
        self.userInfo = try await profileUseCase.fetchUserInfo()
      } catch RepositoryError.dataNotFound {
        self.userInfo = nil
      }
    }
  }
}
