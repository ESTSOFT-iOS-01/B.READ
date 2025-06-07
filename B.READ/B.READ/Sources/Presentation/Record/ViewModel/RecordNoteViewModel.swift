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
  private var notes: [NoteVO] = []
  
  // MARK: - Dependency
//  @Dependency private var noteUseCase: NoteUseCase
  
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
      print("검색어: \(searchText)")
    }
  }
}

private extension RecordNoteViewModel {
  /// 요약노트를 불러와서 뷰에 보여줄 형태로 가공합니다.
  func loadSummarys() {
    Task {
//      do {
//        // 1. 요약노트, 독서기록, 책정보를 튜플의 형태로 가져옵니다.
//        let infos: [(note: AlanSummary, record: Record, book: Book)] = try await noteUseCase.loadSummaryList()
//        
//        // 2. NoteVO 형태로 가공합니다. (Entity -> VO)
//        let allnotes: [NoteVO] = infos.map { NoteVO(record: $0.record, book: $0.book, note: $0.note) }
//      } catch {
//        // 패치 중 오류로 정보를 가져오지 못한 상태
//        self.notes = []
//      }
      
      await MainActor.run {
        setDummy()
        // 3. 선택된 정렬에 맞게 정렬을 진행
        sortDisplayNotes()
      }
    } // : Task
  }
  
  func sortDisplayNotes() {
    self.displayNotes = self.notes.sorted(by: self.selectedSort.sort)
  }
}

// TODO: - [시르] NoteUseCase 추가하면 삭제
private extension RecordNoteViewModel {
  func setDummy() {
    self.notes = [
      NoteVO(
        id: "1",
        bookTitle: "싯타르타",
        author: "헤르만헤세",
        createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 19))!,
        coverImage: Image(.exampleBook),
        content: "테스트테스트테스트테스트테스트테스트",
        recordId: "3"
      ),
      NoteVO(
        id: "2",
        bookTitle: "타이탄의 도구들",
        author: "팀 페리스",
        createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11))!,
        coverImage: Image(.exampleBook),
        content: "트스테트스테트스테트스테트스테트스테트스테트스테트스테ㅍ",
        recordId: "2"
      )
    ]
  }
}
