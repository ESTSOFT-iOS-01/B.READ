//
//  MockNetworkClient.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import Foundation

/// `NetworkClient`의 테스트용 Mock 클래스입니다.
/// 실제 네트워크 요청을 수행하지 않고, 번들에 포함된 JSON 파일을 로드하여 응답을 시뮬레이션합니다.
final class MockNetworkClient: NetworkClient {

  var nextMockFileName: String
  var shouldReturnError: Bool
  var simulatedError: Error = AladinError.unknown

  init(nextMockFileName: String, shouldReturnError: Bool = false) {
    self.nextMockFileName = nextMockFileName
    self.shouldReturnError = shouldReturnError
  }

  override func perform<T: Decodable>(
    _ request: RequestConvertible,
    decodeType: T.Type
  ) async throws -> (T, HTTPURLResponse) {
    if shouldReturnError {
      throw simulatedError
    }

    let data = try Bundle.main.loadDummyJSON(named: nextMockFileName)
    let decoded = try JSONDecoder().decode(T.self, from: data)

    let mockResponse = HTTPURLResponse(
      url: URL(string: "https://mock.aladin.co.kr")!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )!

    return (decoded, mockResponse)
  }

  override func perform(
    _ request: RequestConvertible
  ) async throws -> (Data, HTTPURLResponse) {
    if shouldReturnError {
      throw simulatedError
    }

    let data = try Bundle.main.loadDummyJSON(named: nextMockFileName)

    let mockResponse = HTTPURLResponse(
      url: URL(string: "https://mock.aladin.co.kr")!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )!

    return (data, mockResponse)
  }

  override func performOrDecodeAladinError<T: Decodable>(
    _ request: RequestConvertible,
    decodeType: T.Type
  ) async throws -> T {
    if shouldReturnError {
      throw simulatedError
    }

    let data = try Bundle.main.loadDummyJSON(named: nextMockFileName)
    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      if let aladinError = try? JSONDecoder().decode(AladinErrorDTO.self, from: data) {
        throw AladinError.serverError(code: aladinError.errorCode, message: aladinError.errorMessage)
      } else {
        throw AladinError.decodingError(message: error.localizedDescription)
      }
    }
  }
}

extension Bundle {
  func loadDummyJSON(named name: String) throws -> Data {
    guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
      throw AladinError.decodingError(message: "DummyJson/\(name).json 파일을 찾을 수 없습니다.")
    }
    let url = URL(filePath: path)
    return try Data(contentsOf: url)
  }
}
