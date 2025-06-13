//
//  RecordNoteViewModel.swift
//  B.READ
//
//  Created by 심근웅 on 6/7/25.
//

import Foundation
import SwiftUI

// MARK: - (C)RecordNoteViewModel
final class RecordNoteViewModel: ObservableObject {
  
  // MARK: - State
  @Published var displayNotes: [NoteVO] = []
  @Published var searchText: String = ""
  @Published var selectedSort: SortOption = .recent
  
  // MARK: - Internal Variable
  private(set) var notes: [NoteVO] = []
  
  // MARK: - Dependency
  @Dependency private var summaryUseCase: SummaryUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear
    case selectSort
    case onSubmit
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      loadSummarys()
      
    case .selectSort:
      sortDisplayNotes()
      
    case .onSubmit:
      searchNotes()
    }
  }
}

private extension RecordNoteViewModel {
  /// 요약노트를 불러와서 뷰에 보여줄 형태로 가공합니다.
  func loadSummarys() {
    Task {
      do {
        // 1. 요약노트 정보를 가진 독서기록, 책정보를 튜플의 형태로 가져옵니다.
        let infos: [(record: Record, book: Book)] = try await summaryUseCase.fetchAllSummary()
        
        // 2. NoteVO 형태로 가공합니다. (Entity -> VO)
        let allNotes: [NoteVO] = infos.compactMap { info -> NoteVO? in
          guard let note = info.record.summary else { return nil }
          return NoteVO(note: note, record: info.record, book: info.book)
        }
        
        await MainActor.run {
          // 3. allNotes를 반영
          self.notes = allNotes
          // 4. 검색어 필터를 진행
          searchNotes()
        }
      } catch {
        // 패치 중 오류로 정보를 가져오지 못한 상태
        self.notes = []
      }
    } // : Task
  }
  
  /// 보여주고자 하는 Note의 순서를 정렬합니다.
  func sortDisplayNotes() {
    self.displayNotes = self.displayNotes.sorted(by: self.selectedSort.sort)
  }
  
  ///검색어로 노트를 필터링 합니다.
  func searchNotes() {
    // 1. 검색어가 없으면 전체 노트를 보여줌
    let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      self.searchText = ""
      self.displayNotes = notes
      self.sortDisplayNotes()
      return
    }
    
    // 대소문자 구별하지 않음
    let keyword = searchText.lowercased()
    
    // 2. 책 제목으로 필터링을 진행
    let filteredNotes = notes.filter {
      $0.bookTitle.lowercased().contains(keyword)
    }
    // 3. 필터한 내용을 저장
    self.displayNotes = filteredNotes
    
    // 4. 필터한 내용을 정렬
    self.sortDisplayNotes()
  }
}
