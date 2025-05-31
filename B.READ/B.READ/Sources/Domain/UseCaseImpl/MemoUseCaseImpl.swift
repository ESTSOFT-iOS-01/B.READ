//
//  MemoUseCaseImpl.swift
//  B.READ
//
//  Created by 신승재 on 5/31/25.
//

import Foundation

final class MemoUseCaseImpl: MemoUseCase {
  
  let bookRepository: BookRepository
  let memoRepository: MemoRepository
  let aiService: AIService
  
  init(bookRepository: BookRepository, memoRepository: MemoRepository, aiService: AIService) {
    self.bookRepository = bookRepository
    self.memoRepository = memoRepository
    self.aiService = aiService
  }
  
  func saveMemo(_ memo: Memo) async throws {
    do {
      try await memoRepository.updateMemo(memo)
    } catch RepositoryError.dataNotFound {
      try await memoRepository.createMemo(memo)
    }
  }
  
  func fetchMemo(id: String) async throws -> Memo {
    return try await memoRepository.fetchMemo(id: id)
  }
  
  func generateGuide(isbn: String) async throws {
    
    let book = try await bookRepository.fetchBook(isbn: isbn)
    let prefixPrompt = """
    너는 아래 정보 기반으로 더 깊이 사고할 수 있는 질문을 만드는 AI야.
    책 제목은 \(book.name)이고 저자는 \(book.author)이야.

    - 질문은 구체적이고, 사용자의 생각을 확장시킬 수 있어야 해.
    - 반드시 JSON 배열 형식으로 출력해줘. 예: ["질문1", "질문2", "질문3"]
    
    이 정보를 바탕으로 사용자가 더 깊게 생각할 수 있는 질문 3개를 만들어줘.
    """
    
    // TODO: 그동안의 독서 메모 기록들이 없을때 분기처리
    let memos = try await memoRepository.fetchAllMemos(isbn: isbn)
    if !memos.isEmpty {
      
    }
  }
  
  
}
