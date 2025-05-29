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
  
  @Published var selectedState: ReadingState
  
  @Published var heartRate: Int
  @Published var starRate: Int
  
  @Published var startDate: Date
  @Published var endDate: Date
  
  @Published var page: String
  @Published var isFocused: Bool
  @Published var isTextEditorFocused: Bool
  @Published var reviewText: String
  
  init(
    maxPage: Int,
    selectedState: ReadingState = .notStart,
  ) {
    self.recordVO = nil
    self.maxPage = maxPage
    self.selectedState = selectedState
    self.heartRate = 0
    self.starRate = 0
    self.startDate = Date()
    self.endDate = Date()
    self.page = ""
    self.isFocused = false
    self.isTextEditorFocused = false
    self.reviewText = ""
  }
  
  init(
    recordVO: LibraryRecordVO,
    maxPage: Int,
    selectedState: ReadingState,
    heartRate: Int,
    starRate: Int,
    startDate: Date,
    endDate: Date,
    page: String,
    isFocused: Bool,
    isTextEditorFocused: Bool,
    reviewText: String
  ) {
    self.recordVO = recordVO
    self.maxPage = maxPage
    self.selectedState = 
    self.heartRate = heartRate
    self.starRate = starRate
    self.startDate = startDate
    self.endDate = endDate
    self.page = page
    self.isFocused = isFocused
    self.isTextEditorFocused = isTextEditorFocused
    self.reviewText = reviewText
  }
  

  
}
