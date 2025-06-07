//
//  RecordMemoViewModel.swift
//  B.READ
//
//  Created by 심근웅 on 5/26/25.
//

import Foundation

// MARK: - (C)RecordMemoViewModel
final class RecordMemoViewModel: ObservableObject {
  
  // MARK: - State
  @Published var displayMemoGroups: [MemoGroup] = []
  @Published var searchText: String = ""
  @Published var selectedSort: SortOption = .pageAscending
  
  // MARK: - Internal Variable
  private var memoGroups: [MemoGroup] = []
  var selectedMemo: MemoVO? = nil
  
  // MARK: - Dependency
  @Dependency private var memoUseCase: MemoUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear
    case selectSort
    case onSubmit
    case deleteMemo(id: String)
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      loadMemoGroups()
      
    case .selectSort:
      sortDisplayMemoGroups()
      
    case .onSubmit:
      print("검색어: \(searchText)")
      
    case .deleteMemo(let id):
      deleteMemo(id: id)
    }
  }
}

private extension RecordMemoViewModel {
  /// 메모를 불러와서 뷰에 보여줄 형태로 가공합니다.
  func loadMemoGroups() {
    Task {
      // 1. 전체 문장을 가져옴
      guard let allMemos = try? await memoUseCase.fetchAllMemo() else {
        print("RepositoryError.fetchError.errorDescription")
        return
      }
      
      // 2. 메모를 ISBN을 기준으로 나눔
      let memoDict = Dictionary(grouping: allMemos, by: { $0.isbn })
      
      let memoGroups: [MemoGroup] = await withTaskGroup(of: MemoGroup?.self) {
        [weak self] group in
        guard let self = self else { return [] }
        
        // 3. 구분된 책의 문장을 QuoteGroup으로 생성
        for (isbn, memos) in memoDict {
          group.addTask {
            do {
              let bookTitle = try await self.memoUseCase.loadBookTitle(isbn)
              let memoVOs = memos.map { MemoVO($0) }
              return MemoGroup(isbn: isbn, bookTitle: bookTitle, memos: memoVOs)
            } catch {
              print("ERROR: MemoGroup Create Fail")
              return nil
            }
          }
        }
        
        var results: [MemoGroup] = []
        
        for await result in group {
          if let item = result {
            results.append(item)
          }
        }
        
        return results
      } // : withTaskGroup
      
      // 4. 만들어진 MemoGroup을 반영
      await MainActor.run {
        self.memoGroups = memoGroups
        // 5. MemoGroup 정렬을 진행
        sortDisplayMemoGroups()
      }
    }
  }
  
  /// 보여주고자 하는 Memo의 순서를 정렬합니다.
  func sortDisplayMemoGroups() {
    let sortedGroup = memoGroups
    // 1. 그룹 내부의 메모를 정렬
      .map { group in
        var sortedGroup = group
        sortedGroup.memos = sortedGroup.memos.sorted(by: self.selectedSort.sort)
        return sortedGroup
      }
    // 2. 그룹을 이름 순으로 정렬
      .sorted(by: self.selectedSort.sort)
    
    self.displayMemoGroups = sortedGroup
  }
  
  /// 선택된 메모를 삭제 합니다.
  func deleteMemo(id: String) {
    Task {
      // 1. 데이터 삭제
      try await memoUseCase.deleteMemo(id: id)
      
      // 2. 데이터 일관성을 위해서 새로 데이터를 받아옴
      loadMemoGroups()
    }
  }
}
