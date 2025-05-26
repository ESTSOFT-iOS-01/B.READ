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
  @Published var weeklyStreak: [Bool] = Array(repeating: false, count: 7)
  
  // MARK: - Internal Variable
  private var example: String?
  
  // MARK: - Dependency
  @Dependency
  private var profileUseCase: ProfileUseCase
  
  init() {
    fetchUserInfo()
    print("SettingViewModel 생성")
  }
  
  // MARK: - Action
  enum Action {
    case saveNickname
    case saveCatetories
  }
  
  func send(_ action: Action) {
    switch action {
    case .saveNickname:
      Task.detached(priority: .background) { [weak self] in
        guard let self else { return }
        do {
          try await profileUseCase.setNickname(nicknameText)
        } catch {
          print(error.localizedDescription)
        }
      }
    case .saveCatetories:
      Task.detached(priority: .background) { [weak self] in
        guard let self else { return }
        do {
          try await profileUseCase.setCategory(Array(selectedCategories))
        } catch {
          print(error.localizedDescription)
        }
      }
    }
  }
  
  deinit {
    print("SettingViewModel 소멸")
  }
}

// MARK: - Internal Function
private extension SettingViewModel {
  func fetchUserInfo() {
    Task.detached(priority: .background) { [weak self] in
      guard let self else { return }
      do {
        let userInfo = try await profileUseCase.fetchUserInfo()
        await MainActor.run {
          self.nicknameText = userInfo.nickname
          self.selectedCategories = Set(userInfo.categories.compactMap { CategoryType(rawValue: $0.id) })
          self.weeklyStreak = userInfo.streak.map { $0.isCompleted }
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
