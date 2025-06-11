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
  @Published var highlightKeyword: String? = nil
  
  // MARK: - Internal Variable
  private(set) var memoGroups: [MemoGroup] = []
  var selectedMemo: MemoVO? = nil
  private var currentTask: Task<Void, Never>? = nil
  
  // MARK: - Dependency
  @Dependency private var memoUseCase: MemoUseCase
  @Dependency private var libraryUseCase: LibraryUseCase
  
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
      searchMemos()
      
    case .deleteMemo(let id):
      deleteMemo(id: id)
    }
  }
}

private extension RecordMemoViewModel {
  /// 메모를 불러와서 뷰에 보여줄 형태로 가공합니다.
  func loadMemoGroups() {
    currentTask?.cancel()
    
    currentTask = Task {
      try? Task.checkCancellation()
      
      do {
        // 1. 전체 독서 기록을 받아옴
        let allRecords = try await libraryUseCase.loadRecordList()
        
        // 2. 모든 메모를 VO로 변환
        let allMemos: [MemoVO] = allRecords.flatMap { record, book in
          record.memos.map { MemoVO($0, record: RecordDetailVO(record: record, book: book)) }
        }
        
        // 3. ISBN 기준으로 메모를 그룹화
        let memoDict = Dictionary(grouping: allMemos, by: { $0.isbn })
        
        // 4. TaskGroup을 사용해 각 그룹을 MemoGroup으로 변환
        let memoGroups: [MemoGroup] = await withTaskGroup(of: MemoGroup?.self) {
          [weak self] group in
          guard let self = self else { return [] }
          
          
          for (isbn, memos) in memoDict {
            group.addTask {
              do {
                let bookTitle = try await self.memoUseCase.loadBookTitle(isbn)
                return MemoGroup(isbn: isbn, bookTitle: bookTitle, memos: memos)
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
        
        await MainActor.run {
          // 5. 만들어진 MemoGroup을 반영
          self.memoGroups = memoGroups
          // 6. 검색어 필터를 진행
          searchMemos()
        }
      } catch {
        print("메모 로드 중 문제 발생")
      }
    }
  }
  
  /// 보여주고자 하는 Memo의 순서를 정렬합니다.
  func sortDisplayMemoGroups() {
    let sortedGroup = self.displayMemoGroups
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
  
  /// 검색어로 메모를 필터링 합니다.
  func searchMemos() {
    // 1. 검색어가 없으면 전체 메모를 보여줌(화이트스페이스, 줄바꿈 제거)
    let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      self.searchText = ""
      self.highlightKeyword = nil
      self.displayMemoGroups = memoGroups
      self.sortDisplayMemoGroups()
      return
    }
    
    // 대소문자 구별하지 않음
    let keyword = trimmed.lowercased()
    
    // 2. 메모에서 검색어가 포함된 것을 필터링
    let filteredGroups = memoGroups.compactMap { group -> MemoGroup? in
      // 2-1. 책 제목을 필터링
      let bookTitleMatched = group.bookTitle.lowercased().contains(keyword)
      
      // 2-2. 메모 내용을 필터링
      let matchedMemos = group.memos.filter {
        $0.content.lowercased().contains(keyword)
      }
      
      // 2-3. 책 제목에 포함되면 전부, 내용만 포함되면 필터된 내용만
      if bookTitleMatched || !matchedMemos.isEmpty {
        return MemoGroup(
          isbn: group.isbn,
          bookTitle: group.bookTitle,
          memos: bookTitleMatched ? group.memos : matchedMemos
        )
      } else {
        return nil
      }
    }
    
    // 3. 필터한 내용을 저장
    self.displayMemoGroups = filteredGroups
    
    // 4. 필터한 내용을 정렬
    self.sortDisplayMemoGroups()
    
    // 5. 하이라이트 키워드 반영
    self.highlightKeyword = trimmed
  }
}
