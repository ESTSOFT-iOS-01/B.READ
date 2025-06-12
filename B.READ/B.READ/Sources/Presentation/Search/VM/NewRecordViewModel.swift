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
  var book: Book?
  
  @Published var heartRate: Int
  @Published var starRate: Int
  
  @Published var startDate: Date
  @Published var endDate: Date
  
  @Published var page: String
  @Published var reviewText: String
  
  @Published var isFocused: Bool = false
  @Published var isTextEditorFocused: Bool = false
  @Published var isSuccess: Bool = false
  @Published var inValidPageNumber: Bool = false
  
  var totalPage: Int
  private var pageNum: Int = 0
  
  // MARK: - Dependency
  @Dependency private var libraryUseCase: LibraryUseCase
  
  /// Search에서 새로운 Record 만드는 경우
  init(
    book: Book
  ) {
    self.recordVO = nil
    self.heartRate = 0
    self.starRate = 0
    self.startDate = .now
    self.endDate = .now
    self.page = ""
    self.reviewText = ""
    self.book = book
    self.totalPage = book.totalPages
  }
  
  /// Library에서 Record 수정하는 경우
  init(
    recordVO: RecordDetailVO
  ) {
    self.recordVO = recordVO
    self.heartRate = recordVO.heart
    self.starRate = recordVO.star
    self.startDate = recordVO.period.startDate ?? .now
    self.endDate = recordVO.period.endDate ?? .now
    self.page = String(recordVO.currentPage)
    self.reviewText = recordVO.review
    self.totalPage = recordVO.totalPage
    self.book = nil
  }
  
  // MARK: - Action
  enum Action {
    case updateRecord(ReadingState)
    case createRecord(ReadingState)
    case pageSubmit
    case releaseEditorFocus
    case focusOnTextField
    case releaseAllFocus
  }
  
  func send(_ action: Action) {
    switch action {
    case let .createRecord(state):
      if let entity = setEntityByBook(state) {
        saveNewRecord(entity)
      }
      
    case let .updateRecord(state):
      if let entity = setEntity(state) {
        updateRecord(entity)
      }

    case .pageSubmit:
      isFocused = false
      if let value = Int(page), value >= 0, value <= totalPage {
        pageNum = value
        inValidPageNumber = false
      } else {
        pageNum = 0
        page = "0"
        inValidPageNumber = true
      }
      
    case .releaseEditorFocus:
      DispatchQueue.main.async { [weak self] in
        self?.isTextEditorFocused = false
      }
      
    case .focusOnTextField:
      DispatchQueue.main.async { [weak self] in
        self?.isFocused = true
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
  func setEntity(_ state: ReadingState) -> Record? {
    guard let origin = self.recordVO else { return nil }
    
    switch state {
    case .notStart:
      return Record(
        id: origin.id,
        isbn: origin.isbn,
        state: state.toEntity(),
        heartCount: heartRate,
        starCount: 0,
        isFavorite: origin.isFavorite,
        period: (nil, nil),
        currentPage: 0,
        review: "",
        memos: [],
        quotes: [],
        createdAt: origin.createdAt,
        updatedAt: .now
      )
    case .reading:
      return Record(
        id: origin.id,
        isbn: origin.isbn,
        state: state.toEntity(),
        heartCount: origin.heart,
        starCount: 0,
        isFavorite: origin.isFavorite,
        period: (startDate, nil),
        currentPage: pageNum,
        review: "",
        memos: [],
        quotes: [],
        createdAt: origin.createdAt,
        updatedAt: .now
      )
    case .finished:
      return Record(
        id: origin.id,
        isbn: origin.isbn,
        state: state.toEntity(),
        heartCount: origin.heart,
        starCount: starRate,
        isFavorite: origin.isFavorite,
        period: (startDate, endDate),
        currentPage: origin.currentPage,
        review: reviewText,
        memos: [],
        quotes: [],
        createdAt: origin.createdAt,
        updatedAt: .now
      )
    }
  }
  
  func setEntityByBook(_ state: ReadingState) -> Record? {
    guard let book = self.book else { return nil }
    
    switch state {
    case .notStart:
      return Record(
        id: UUID().uuidString,
        isbn: book.isbn,
        state: state.toEntity(),
        heartCount: heartRate,
        starCount: 0,
        isFavorite: false,
        period: (nil, nil),
        currentPage: 0,
        review: "",
        memos: [],
        quotes: [],
        createdAt: .now,
        updatedAt: .now
      )
    case .reading:
      return Record(
        id: UUID().uuidString,
        isbn: book.isbn,
        state: state.toEntity(),
        heartCount: 0,
        starCount: 0,
        isFavorite: false,
        period: (startDate, nil),
        currentPage: pageNum,
        review: "",
        memos: [],
        quotes: [],
        createdAt: .now,
        updatedAt: .now
      )
    case .finished:
      return Record(
        id: UUID().uuidString,
        isbn: book.isbn,
        state: state.toEntity(),
        heartCount: 0,
        starCount: starRate,
        isFavorite: false,
        period: (startDate, endDate),
        currentPage: totalPage,
        review: reviewText,
        memos: [],
        quotes: [],
        createdAt: .now,
        updatedAt: .now
      )
    }
  }
  
  func saveNewRecord(_ record: Record) {
    guard let book = self.book else { return }

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
