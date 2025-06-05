//
//  HomeViewModel.swift
//  B.READ
//
//  Created by 신승재 on 5/29/25.
//

import Foundation

final class HomeViewModel: ObservableObject {
  
  // MARK: - State
  @Published var recentRecords: [RecordCellVO] = []
  @Published var bestSellerList: [BestSellerListVO] = [
//    BestSellerListVO(category: CategoryType.literature, bestSellers: [], state: .loading),
//    BestSellerListVO(category: CategoryType.literature, bestSellers: [], state: .loading)
  ]
  
  var currentTask: Task<Void, Never>? = nil
  
  // MARK: - Dependency
  @Dependency private var libraryUseCase: LibraryUseCase
  @Dependency private var recommandUseCase: RecommandUseCase
  @Dependency private var profileUseCase: ProfileUseCase
  
  init() {
    //print("HomeViewModel 생성")
  }
  
  // MARK: - Action
  enum Action {
    case onAppear
    case fetchBestSeller
    case cancelTask
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      fetchRecentRecords()
      fetchCategories()
    case .fetchBestSeller:
      fetchCategories()
    case .cancelTask:
      currentTask?.cancel()
    }
  }
  
  deinit {
    // print("HomeViewModel 소멸")
  }
}

// MARK: - Internal Function
private extension HomeViewModel {
  func fetchRecentRecords() {
    Task {
      let records = try await libraryUseCase.loadRecentUpdatedReadingRecord(maxCount: 3)
      await MainActor.run {
        self.recentRecords = records.map { RecordCellVO(record: $0, book: $1) }
      }
    }
  }
  
  func fetchCategories() {
    currentTask?.cancel()
    
    currentTask = Task {
      do {
        let data = try await profileUseCase.fetchUserInfo()
        
        let lists: [BestSellerListVO] = data.categories.compactMap { category in
          guard let categoryType = CategoryType(rawValue: category.id) else { return nil }
          return BestSellerListVO(category: categoryType, bestSellers: [], state: .loading)
        }
        
        await MainActor.run {
          self.bestSellerList = lists
        }
        
        await self.fetchBestSellers(for: lists.map(\.category))
        
      } catch {
        print("추천 카테고리 불러오기 실패: \(error)")
      }
    }
  }

  func fetchBestSellers(for categories: [CategoryType]) async {
    let results: [BestSellerListVO?] = await withTaskGroup(of: BestSellerListVO?.self) { group in
      for category in categories {
        group.addTask {
          do {
            try Task.checkCancellation()
            let raw = try await self.recommandUseCase.requestBestSeller(in: category.cid)
            let bestSellers = raw.compactMap { BestSellerVO($0) }
            let topFive = Array(bestSellers.prefix(5))
            return BestSellerListVO(category: category, bestSellers: topFive, state: .loaded)
            
          } catch {
            if Task.isCancelled {
              print("\(#function) is cancelled")
              return BestSellerListVO(category: category, bestSellers: [], state: .failed(error))
            }
            return BestSellerListVO(category: category, bestSellers: [], state: .failed(error))
          }
        }
      }

      return await group.reduce(into: [BestSellerListVO?]()) { $0.append($1) }
    }

    await MainActor.run {
      self.bestSellerList = results.compactMap { $0 }
    }
    
  }
  
}

