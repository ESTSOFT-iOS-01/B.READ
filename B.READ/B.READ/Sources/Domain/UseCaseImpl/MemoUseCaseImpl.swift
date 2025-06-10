//
//  MemoUseCaseImpl.swift
//  B.READ
//
//  Created by 신승재 on 5/31/25.
//

import Foundation

final class MemoUseCaseImpl: MemoUseCase {
  
  let userInfoRepository: UserInfoRepository
  let bookRepository: BookRepository
  let memoRepository: MemoRepository
  let aiService: AIService
  
  init(
    userInfoRepository: UserInfoRepository,
    bookRepository: BookRepository,
    memoRepository: MemoRepository,
    aiService: AIService
  ) {
    self.userInfoRepository = userInfoRepository
    self.bookRepository = bookRepository
    self.memoRepository = memoRepository
    self.aiService = aiService
  }
  
  func saveMemo(_ memo: Memo, in record: Record) async throws {
    do {
      try await memoRepository.updateMemo(memo)
    } catch RepositoryError.dataNotFound {
      try await memoRepository.createMemo(memo, in: record)
    }
    
    try await self.updateStreakIfNeeded()
  }
  
  func fetchMemo(id: String) async throws -> Memo {
    return try await memoRepository.fetchMemo(id: id)
  }
  
  func fetchAllMemo() async throws -> [Memo] {
    return try await memoRepository.fetchAllMemos()
  }
  
  func deleteMemo(id: String) async throws {
    return try await memoRepository.deleteMemo(id: id)
  }
  
  func generateGuide(isbn: String) async throws -> [Guide] {
    
    let book = try await bookRepository.fetchBook(isbn: isbn)
    let prefixPrompt = """
    너는 아래 정보 기반으로 더 깊이 사고할 수 있는 질문을 만드는 AI야.
    책 제목은 \(book.name)이고 저자는 \(book.author)이야.

    - 질문은 구체적이고, 사용자의 생각을 확장시킬 수 있어야 해.
    - 반드시 JSON 배열 형식으로 출력해줘. 예: ["질문1", "질문2", "질문3"]
    - 코드 블록에 넣지는 말아줘
    """
    
    let memos = try await memoRepository.fetchAllMemos(isbn: isbn)
    let middlePrompt = memos.map { $0.content }.joined()
    
    let suffixPrompt = "이 정보를 바탕으로 사용자가 더 깊게 생각할 수 있는 질문 3개를 만들어줘."
    
    var jsonString = try await aiService.request(prompt: prefixPrompt + middlePrompt + suffixPrompt)
    
    var attempt = 0
    while attempt < 2 {
      do {
        let data = Data(jsonString.utf8)
        let contents = try JSONDecoder().decode([String].self, from: data)
        
        return contents.map { Guide(date: .now, content: $0) }
      } catch {
        attempt += 1
        let retryPrompt = """
        파싱 형태가 잘못되었어.
        반드시 JSON 배열 형식으로 출력해줘. 예: ["질문1", "질문2", "질문3"]
        그리고 코드 블록에 넣지는 말아줘
        """
        jsonString = try await aiService.request(prompt: retryPrompt)
      }
    }
    
    throw MemoUseCaseError.parsingError
  }
  
  func loadBookTitle(_ isbn: String) async throws -> String {
    return try await bookRepository.fetchBook(isbn: isbn).name
  }
}

private extension MemoUseCaseImpl {
  func updateStreakIfNeeded() async throws {
    let currentTime: Date = .now
    
    var userInfo = try await userInfoRepository.fetchUserInfo()
    if userInfo.lastStreakUpdatedAt.isSameDay(as: currentTime) { return }
  
    if userInfo.lastStreakUpdatedAt.isInCurrentWeek {
      userInfo.streak = userInfo.streak.map { DailyStatus(weekday: $0.weekday, isCompleted: false) }
    }
    
    userInfo.streak[currentTime.weekdayInt - 1] = DailyStatus(weekday: currentTime.weekdayInt - 1, isCompleted: true)
    userInfo.lastStreakUpdatedAt = currentTime
    
    try await userInfoRepository.updateUserInfo(userInfo)
  }
}
