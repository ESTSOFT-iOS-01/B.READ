//
//  MemoRepository.swift
//  B.READ
//
//  Created by 신승재 on 5/30/25.
//

import Foundation

protocol MemoRepository {
  
  func createMemo(_ memo: Memo) async throws
  
  func fetchMemo(id: String) async throws -> Memo
  
  func fetchAllMemos() async throws -> [Memo]
  
  func fetchAllMemos(isbn: String) async throws -> [Memo]
  
  func fetchAllMemos(containg text: String) async throws -> [Memo]
  
  func updateMemo(_ memo: Memo) async throws
  
  func deleteMemo(id: String) async throws
  
}
