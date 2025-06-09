//
//  MemoUseCase.swift
//  B.READ
//
//  Created by 신승재 on 5/30/25.
//

import Foundation

protocol MemoUseCase {
  /// 메모를 저장합니다.
  /// 이미 존재하는 메모의 경우 업데이트하며, 존재하지 않으면 새로 생성됩니다.
  ///
  /// - Parameters:
  ///   - memo: 저장할 `Memo` 객체
  ///   - record: 메모를 저장할 대상 `Record` 객체
  /// - Throws: `RepositoryError.dataNotFound`, `RepositoryError.dataAlreadyExist`, 저장 중 오류 발생 시
  func saveMemo(_ memo: Memo, in record: Record) async throws
  
  /// ID를 통해 특정 메모를 조회합니다.
  ///
  /// - Parameter id: 조회할 메모의 고유 식별자
  /// - Returns: 해당 ID에 해당하는 `Memo` 객체
  /// - Throws: `RepositoryError.dataNotFound`, 조회 실패 시 오류 발생
  func fetchMemo(id: String) async throws -> Memo
  
  /// 모든 메모를 조회합니다.
  ///
  /// - Returns: 모든 `Memo` 객체
  /// - Throws: `RepositoryError.dataNotFound`, 조회 실패 시 오류 발생
  func fetchAllMemo() async throws -> [Memo]
  
  /// ID를 통해 특정 메모를 삭제합니다.
  ///
  /// - Parameter id: 삭제할 메모의 고유 식별자
  /// - Returns: 해당 ID에 해당하는 `Memo` 객체
  /// - Throws: `RepositoryError.dataNotFound`, 조회 실패 시 오류 발생
  func deleteMemo(id: String) async throws
  
  /// AI에게 메모 기반 질문 생성을 요청합니다.
  /// 동일 ISBN을 가지는 메모 내용을 기반으로 질문 3개를 생성합니다.
  ///
  /// - Parameter isbn: 메모가 속한 책의 ISBN 번호
  /// - Returns: JSON 형식의 질문 배열 문자열 예: `["질문1", "질문2", "질문3"]`
  /// - Throws: `RepositoryError.dataNotFound`, `AIServiceError`, 등 조회 및 요청 오류
  func generateGuide(isbn: String) async throws -> [Guide]
  
  /// ISBN 값을 가지고 도서 제목을 조회합니다.
  ///
  /// - Parameter isbn: 조회할 도서의 ISBN
  /// - Returns: 조회한 도서의 제목
  /// - Throws:
  ///   - `RepositoryError.dataNotFound`: 조회한 도서 정보가 존재하지 않는경우
  ///   - `RepositoryError.fetchError`: 도서 정보 조회 과정에서 저장소 조회 중 에러가 발생한 경우
  func loadBookTitle(_ isbn: String) async throws -> String
}

enum MemoUseCaseError {
  case parsingError
}

extension MemoUseCaseError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .parsingError:
      "Parsing error"
    }
  }
}

