//
//  NewRecordViewModel.swift
//  B.READ
//
//  Created by 김도연 on 5/29/25.
//

import Foundation
import SwiftUI


final class NewRecordViewModel: ObservableObject {
  // MARK: - State
  var recordVO: RecordDetailVO?
  var book: Book
  
  @Published var heartRate: Int
  @Published var starRate: Int
  
  @Published var startDate: Date
  @Published var endDate: Date
  
  @Published var page: String
  @Published var isFocused: Bool = false
  @Published var isTextEditorFocused: Bool = false
  @Published var reviewText: String
  
  @Published var isSuccess: Bool = false
  
  var pageNum : Int = 0
  
  // MARK: - Dependency
  @Dependency private var libraryUseCase: LibraryUseCase
  
  /// Search에서 새로운 Record 만드는 경우
  init(
    book: Book
  ) {
    self.recordVO = nil
    self.heartRate = 0
    self.starRate = 0
    self.startDate = Date()
    self.endDate = Date()
    self.page = ""
    self.reviewText = ""
    self.book = book
  }
  
  /// Library에서 Record 수정하는 경우
  init(
    recordVO: RecordDetailVO,
    book: Book
  ) {
    self.recordVO = recordVO
    self.heartRate = recordVO.heart
    self.starRate = recordVO.star
    self.startDate = recordVO.period.startDate ?? Date()
    self.endDate = recordVO.period.endDate ?? Date()
    self.page = String(recordVO.currentPage)
    self.reviewText = recordVO.review
    self.book = book
  }
  
  // MARK: - Action
  enum Action {
    case onSubmit(ReadingState)
    case pageSubmit
    case releaseEditorFocus
    case releaseAllFocus
  }
  
  func send(_ action: Action) {
    switch action {
    case .onSubmit(let state):
      let entity = setEntity(state)
      if recordVO != nil {
        updateRecord(entity)
      } else {
        saveNewRecord(entity)
      }

    case .pageSubmit:
      isFocused = false
      if let value = Int(page), value >= 0, value <= book.totalPages {
        pageNum = value
      } else {
        pageNum = 0
      }
      
    case .releaseEditorFocus:
      DispatchQueue.main.async { [weak self] in
        self?.isTextEditorFocused = false
      }
    case .releaseAllFocus:
      DispatchQueue.main.async { [weak self] in
        self?.isFocused = false
        self?.isTextEditorFocused = false
      }
    }
  }
  
}


private extension NewRecordViewModel {
  func setEntity(_ state: ReadingState) -> Record {
    if let origin = recordVO {
      return Record(
        id: origin.id,
        isbn: origin.isbn,
        state: state.toEntity(),
        heartCount: heartRate,
        starCount: starRate,
        isFavorite: origin.isFavorite,
        period: (startDate, endDate),
        currentPage: pageNum,
        review: reviewText,
        memos: [],
        quotes: [],
        createdAt: origin.createdAt,
        updatedAt: .now
      )
    } else {
      return Record(
        id: UUID().uuidString,
        isbn: book.isbn,
        state: state.toEntity(),
        heartCount: heartRate,
        starCount: starRate,
        isFavorite: false,
        period: (startDate, endDate),
        currentPage: pageNum,
        review: reviewText,
        memos: [],
        quotes: [],
        createdAt: .now,
        updatedAt: .now
      )
    }
  }
  
  func saveNewRecord(_ record: Record) {
    Task {
      do {
        try await libraryUseCase.saveRecord(record: record, book: book)
        await MainActor.run { isSuccess = true }
      } catch {
        print(error)
      }
    }
  }
  
  func updateRecord(_ record: Record) {
    Task {
      do {
        try await libraryUseCase.editRecord(record)
        await MainActor.run { isSuccess = true }
      } catch {
        print(error)
      }
    }
  }
}
