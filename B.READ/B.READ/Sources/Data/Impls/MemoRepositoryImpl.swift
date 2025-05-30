//
//  MemoRepositoryImpl.swift
//  B.READ
//
//  Created by 신승재 on 5/30/25.
//

import Foundation
import SwiftData

@ModelActor
actor MemoRepositoryImpl: MemoRepository {
  func createMemo(_ memo: Memo) async throws {
    print("Impl: ", #function)
    
    if let _ = try findMemo(id: memo.id) {
      throw RepositoryError.dataAlreadyExist
    }
    
    let model = MemoDTO(memo)
    modelContext.insert(model)
    
    try modelContext.save()
  }
  
  func fetchMemo(id: String) async throws -> Memo {
    print("Impl: ", #function)
    
    guard let data = try findMemo(id: id) else {
      throw RepositoryError.dataNotFound
    }
    
    return data.toEntity()
  }
  
  func fetchAllMemos() async throws -> [Memo] {
    print("Impl: ", #function)
    
    let sort = SortDescriptor(\MemoDTO.createdAt, order: .reverse)
    let descriptor = FetchDescriptor<MemoDTO>(sortBy: [sort])
    
    do {
      let data = try modelContext.fetch(descriptor)
      return data.map { $0.toEntity() }
    } catch {
      throw RepositoryError.fetchError
    }
  }
  
  func fetchAllMemos(isbn: String) async throws -> [Memo] {
    print("Impl: ", #function)
    
    let predicate = #Predicate<MemoDTO> { $0.isbn == isbn }
    let sort = SortDescriptor(\MemoDTO.createdAt, order: .reverse)
    let descriptor = FetchDescriptor(predicate: predicate, sortBy: [sort])
    
    do {
      let data = try modelContext.fetch(descriptor)
      return data.map { $0.toEntity() }
    } catch {
      throw RepositoryError.fetchError
    }
  }
  
  func fetchAllMemos(containg text: String) async throws -> [Memo] {
    print("Impl: ", #function)
    
    // String.localizedStandardContains?
    // 대소문자와 발음 구별 기호를 구분하지 않고 locale을 인식하여 검색을 수행하여 문자열에 주어진 문자열이 포함되어 있는지 여부
    let predicate = #Predicate<MemoDTO> { $0.content.localizedStandardContains(text) }
    let sort = SortDescriptor(\MemoDTO.createdAt, order: .reverse)
    let descriptor = FetchDescriptor(predicate: predicate, sortBy: [sort])
    
    do {
      let data = try modelContext.fetch(descriptor)
      return data.map { $0.toEntity() }
    } catch {
      throw RepositoryError.fetchError
    }
  }
  
  func updateMemo(_ memo: Memo) async throws {
    print("Impl: ", #function)
    
    guard let data = try findMemo(id: memo.id) else {
      throw RepositoryError.dataNotFound
    }
    
    data.isbn = memo.isbn
    data.createdAt = memo.createdAt
    data.content = memo.content
    data.startPage = memo.pages.0
    data.endPage = memo.pages.1
    data.guides = memo.guides.map { GuideDTO($0) }
    
    try modelContext.save()
  }
  
  func deleteMemo(id: String) async throws {
    print("Impl: ", #function)
    
    guard let data = try findMemo(id: id) else {
      throw RepositoryError.dataNotFound
    }
    
    modelContext.delete(data)
  }
}

private extension MemoRepositoryImpl {
  /// 저장소에서 `MemoDTO`를 조회합니다.
  ///
  /// - Parameter id: Memo의 id
  /// - Returns: `MemoDTO`: 조회된 첫 번째 책 정보 DTO, 없으면 `nil`
  /// - Throws:
  ///   - `RepositoryError.fetchError`
  func findMemo(id: String) throws -> MemoDTO? {
    let predicate = #Predicate<MemoDTO> { $0.id == id }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    do {
      return try modelContext.fetch(descriptor).first
    } catch {
      throw RepositoryError.fetchError
    }
  }
}
