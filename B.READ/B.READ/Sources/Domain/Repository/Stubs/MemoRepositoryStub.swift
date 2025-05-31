//
//  MemoRepositoryStub.swift
//  B.READ
//
//  Created by 신승재 on 5/30/25.
//

import Foundation

actor MemoRepositoryStub: MemoRepository {
  private var memos: [Memo] = []

  func createMemo(_ memo: Memo) async throws {
    if memos.contains(where: { $0.id == memo.id }) {
      throw RepositoryError.dataAlreadyExist
    }
    memos.append(memo)
  }

  func fetchMemo(id: String) async throws -> Memo {
    guard let memo = memos.first(where: { $0.id == id }) else {
      throw RepositoryError.dataNotFound
    }
    return memo
  }

  func fetchAllMemos() async throws -> [Memo] {
    return memos
  }

  func fetchAllMemos(isbn: String) async throws -> [Memo] {
    return memos.filter { $0.isbn == isbn }
  }

  func fetchAllMemos(containing text: String) async throws -> [Memo] {
    return memos.filter { $0.content.localizedCaseInsensitiveContains(text) }
  }

  func updateMemo(_ memo: Memo) async throws {
    guard let index = memos.firstIndex(where: { $0.id == memo.id }) else {
      throw RepositoryError.dataNotFound
    }
    memos[index] = memo
  }

  func deleteMemo(id: String) async throws {
    guard let index = memos.firstIndex(where: { $0.id == id }) else {
      throw RepositoryError.dataNotFound
    }
    memos.remove(at: index)
  }
}
