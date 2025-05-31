//
//  MemoUseCase.swift
//  B.READ
//
//  Created by 신승재 on 5/30/25.
//

import Foundation

protocol MemoUseCase {
  func saveMemo(_ memo: Memo) async throws
  
  func fetchMemo(id: String) async throws -> Memo
  
  func generateGuide(isbn: String) async throws
}

//Memo(id: , isbn: , createdAt: , content: , pages: , guides: )
// - 메모 작성 저장
//- 메모 가져오기
//- AI 메모 제안 기능
