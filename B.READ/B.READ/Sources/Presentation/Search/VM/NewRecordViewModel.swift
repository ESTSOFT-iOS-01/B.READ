//
//  NewRecordViewModel.swift
//  B.READ
//
//  Created by 김도연 on 5/29/25.
//


import Foundation
import SwiftUI

final class NewRecordViewModel: ObservableObject {
  var recordVO: LibraryRecordVO?
  
  var maxPage: Int = 100
  
  @Binding var selectedState: ReadingState
  
  @Published var heartRate: Int
  @Published var starRate: Int
  
  @Published var startDate: Date
  @Published var endDate: Date
  
  @Published var page: String
  @Published var isFocused: Bool = false
  @Published var isTextEditorFocused: Bool = false
  @Published var reviewText: String
  
  @Published var isSuccess: Bool = false
  
  /// Search에서 새로운 Record 만드는 경우
  init(
    maxPage: Int,
    selectedState: Binding<ReadingState>,
  ) {
    self.recordVO = nil
    self.maxPage = maxPage
    self._selectedState = selectedState
    self.heartRate = 0
    self.starRate = 0
    self.startDate = Date()
    self.endDate = Date()
    self.page = ""
    self.reviewText = ""
  }
  
  /// Library에서 Record 수정하는 경우
  init(
    recordVO: LibraryRecordVO,
    selectedState: Binding<ReadingState>,
    maxPage: Int,
  ) {
    self.recordVO = recordVO
    self.maxPage = maxPage
    self._selectedState = selectedState
    self.heartRate = recordVO.heartCount
    self.starRate = recordVO.starCount
    self.startDate = recordVO.period.start ?? Date()
    self.endDate = recordVO.period.end ?? Date()
    self.page = String(recordVO.currentPage)
    // TODO : LibraryRecordVO에 reviewText 생기면 넣어주기
    self.reviewText = ""
  }
  
  // MARK: - Action
  enum Action {
    case onSubmit
    case pageSubmit
    case releaseEditorFocus
  }

  func send(_ action: Action) {
    switch action {
    case .onSubmit:
      // usecase의 save함수 부르기
      // 성공하면 dismiss
      // 실패하면 재시도 1회 후, alert로 실패 메세지 띄우기
      print("저장하기 버튼 눌림")
      
      Task {
        try await Task.sleep(for: .seconds(2.0))
        await MainActor.run { isSuccess = true }
      }
    case .pageSubmit:
      isFocused = false
    case .releaseEditorFocus:
      isTextEditorFocused = false
    }
  }

}
