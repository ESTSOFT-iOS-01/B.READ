//
//  SummaryUseCaseImpl.swift
//  B.READ
//
//  Created by 김도연 on 6/9/25.
//

import Foundation

final class SummaryUseCaseImpl: SummaryUseCase {
  let summaryRepository: SummaryRepository
  let bookRepository: BookRepository
  let recordRepository: RecordRepository
  let aiService: AIService
  
  init(
    summaryRepository: SummaryRepository,
    bookRepository: BookRepository,
    recordRepository: RecordRepository,
    aiService: AIService
  ) {
    self.summaryRepository = summaryRepository
    self.bookRepository = bookRepository
    self.recordRepository = recordRepository
    self.aiService = aiService
  }
  
  func saveSummary(_ summary: AlanSummary, in record: Record) async throws {
    try await summaryRepository.createSummary(summary, in: record)
  }
  
  func generateSummary(in record: Record) async throws -> AlanSummary {
    let book = try await bookRepository.fetchBook(isbn: record.isbn)
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
      let jsonString = try await aiService.request(prompt: prompt)
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
    return try await summaryRepository.fetchSummary(id: id)
  }
  
  func fetchAllSummary() async throws -> [AlanSummary] {
    return try await summaryRepository.fetchAllSummary()
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
}
