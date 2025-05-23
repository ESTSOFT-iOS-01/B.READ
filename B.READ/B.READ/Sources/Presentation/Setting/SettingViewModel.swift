//
//  SettingViewModel.swift
//  B.READ
//
//  Created by 신승재 on 5/22/25.
//

import Foundation

final class SettingViewModel: ObservableObject {
  
  // MARK: - State
  @Published var nicknameText: String = ""
  @Published var selectedCategories: Set<CategoryType> = []
  
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
    case saveNickname
    case saveCatetories
  }
  
  func send(_ action: Action) {
    switch action {
    case .saveNickname:
      Task {
        do {
          try await profileUseCase.setNickname(nicknameText)
        } catch {
          print(error.localizedDescription)
        }
      }
    case .saveCatetories:
      Task {
        do {
          try await profileUseCase.setCategory(Array(selectedCategories))
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
        let userInfo = try await profileUseCase.fetchUserInfo()
        self.nicknameText = userInfo.nickname
        self.selectedCategories = Set(userInfo.categories.compactMap { CategoryType(rawValue: $0.id) })
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
