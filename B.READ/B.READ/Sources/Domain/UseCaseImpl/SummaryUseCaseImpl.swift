//
//  SummaryUseCaseImpl.swift
//  B.READ
//
//  Created by 김도연 on 6/9/25.
//

import Foundation

final class SummaryUseCaseImpl: SummaryUseCase {
  
  let userInfoRepository: UserInfoRepository
  let summaryRepository: SummaryRepository
  let bookRepository: BookRepository
  let recordRepository: RecordRepository
  let aiService: AIService
  
  init(
    userInfoRepository: UserInfoRepository,
    summaryRepository: SummaryRepository,
    bookRepository: BookRepository,
    recordRepository: RecordRepository,
    aiService: AIService
  ) {
    self.userInfoRepository = userInfoRepository
    self.summaryRepository = summaryRepository
    self.bookRepository = bookRepository
    self.recordRepository = recordRepository
    self.aiService = aiService
  }
  
  func saveSummary(_ summary: AlanSummary, in record: Record) async throws {
    try Task.checkCancellation()
    try await summaryRepository.createSummary(summary, in: record)
    try Task.checkCancellation()
    try await self.updateStreakIfNeeded()
  }
  
  func generateSummary(in record: Record) async throws -> AlanSummary {
    try Task.checkCancellation()
    let book = try await bookRepository.fetchBook(isbn: record.isbn)
    try Task.checkCancellation()
    let prefixPrompt = """
      You are an AI that generates a reading reflection summary based on the following information.
      Book title: \(book.name), Author: \(book.author)
      When the user provides these details plus their collected quotes and memos, reply only with a valid JSON object matching this schema:
      {"Summary": string, "feelingTags": [ string ] }
      
      Rules:
      1. Your entire reply must be a single JSON object parsable by a standard JSON parser.
      2. The very first character of your response must be { and the very last character must be }.
      3. Do not wrap the JSON in any quotes, markdown fences, or extra fields (e.g. no "action" wrapper).
      4. Do not include any keys other than "Summary", "feelingTags".
      5. Extract exactly five human emotion tags for "feelingTags".
      6. The "Summary" field must include all user-provided memos and be as detailed and lengthy as possible.
      7. If you cannot fulfill the request, respond with:
      {
      "error": "description of the problem"
      }
      
      User’s memos:
      """
    
    var attempt = 0

    while attempt < 3 {
      let memoContent = trimmedMemoContent(from: record.memos, retryCount: attempt)
      let prompt = prefixPrompt + memoContent
      try Task.checkCancellation()
      let jsonString = try await aiService.request(prompt: prompt)
      try Task.checkCancellation()
      let data = Data(jsonString.utf8)

      do {
        let contents = try JSONDecoder().decode(ResponseSummary.self, from: data)
        let tags = contents.feelingTags.map { Tag($0) }

        return AlanSummary(
          id: UUID().uuidString,
          isbn: book.isbn,
          content: contents.summary,
          tags: tags,
          createdAt: .now
        )
      } catch {
        do {
          let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
          throw SummaryUseCaseError.promptError(errorResponse.error)
        } catch {
          attempt += 1
        }
      }
    }
    
    throw SummaryUseCaseError.fatalError
  }

  
  func fetchSummary(id: String) async throws -> AlanSummary {
    try Task.checkCancellation()
    let summary = try await summaryRepository.fetchSummary(id: id)
    try Task.checkCancellation()
    
    return summary
  }
  
  func fetchAllSummary() async throws -> [(Record, Book)] {
    let noteInfos: [(Record, Book)]
    
    // 1. 요약노트가 있는 독서 기록 정보 패치
    let records = try await recordRepository.fetchHaveSummaryRecords()
    
    // 2. 태스크 그룹으로 정보를 가져옴
    noteInfos = try await withThrowingTaskGroup(of: (Record, Book)?.self) {
      [weak self] group in
      guard let self = self else { return [] }
      
      for record in records {
        // 3. record 기준으로 각각의 책정보 가져오는 걸 자식 태스크로 지정
        group.addTask {
          do {
            let book = try await self.bookRepository.fetchBook(isbn: record.isbn)
            return (record, book)
          } catch {
            // TODO: - RepositoryError.dataNotFound이면 알라딘에서 책검색, 아니면 nil
            print(error.localizedDescription)
            return nil
          }
        }
      }
      
      var results: [(Record, Book)] = []
      // 4. 태스크 그룹의 결과를 results에 저장
      for try await result in group {
        if let info = result {
          results.append(info)
        }
      }
      
      return results
    }
  
    return noteInfos
  }
}

private extension SummaryUseCaseImpl {
  /// memo 리스트에서 뒤에서부터 N개 제거한 뒤, 하나의 문자열로 병합
  ///
  /// - Parameters:
  ///   - memos: 원본 Memo 리스트
  ///   - retryCount: 제거할 메모 개수
  /// - Returns: 연결된 메모 문자열
  func trimmedMemoContent(from memos: [Memo], retryCount: Int) -> String {
    guard retryCount < memos.count else {
      return ""
    }
    let trimmed = Array(memos.prefix(memos.count - retryCount))
    return trimmed.map { $0.content }.joined(separator: " ")
  }
  
  func updateStreakIfNeeded() async throws {
      let currentTime: Date = .now
      
      var userInfo = try await userInfoRepository.fetchUserInfo()
      // 같은 날짜에 이미 업데이트가 이루어졌다면 return
      if userInfo.lastStreakUpdatedAt.isSameDay(as: currentTime) { return }
      
      // 스트릭이 이번주의 첫 스트릭일 경우 초기화
      if !userInfo.lastStreakUpdatedAt.isInCurrentWeek {
        userInfo.streak = userInfo.streak.map { DailyStatus(weekday: $0.weekday, isCompleted: false) }
      }
      
      // 업데이트
      userInfo.streak[currentTime.weekdayInt - 1] = DailyStatus(weekday: currentTime.weekdayInt - 1, isCompleted: true)
      userInfo.lastStreakUpdatedAt = currentTime
      
      try await userInfoRepository.updateUserInfo(userInfo)
    }
}
