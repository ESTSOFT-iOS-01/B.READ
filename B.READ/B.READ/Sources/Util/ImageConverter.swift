//
//  ImageConverter.swift
//  B.READ
//
//  Created by 김도연 on 5/31/25.
//

import Foundation
import UIKit

/// 이미지 URL 문자열을 `Data`로 변환하는 중 발생할 수 있는 에러 유형.
enum ImageConversionError: Error {
  case invalidURL
  case downloadFailed
  case imageConversionFailed
}

/// 이미지 URL 문자열을 비동기적으로 `Data`로 변환하는 유틸리티 클래스입니다.
class ImageConverter {
  /// 이미지 URL 문자열을 `Data`로 변환합니다.
  ///
  /// - Parameter urlString: 이미지가 위치한 URL 문자열입니다.
  /// - Returns: JPEG 형식으로 인코딩된 이미지 `Data`.
  /// - Throws: `ImageConversionError` 중 하나의 오류가 발생할 수 있습니다.
  static func convertImageURLToData(_ urlString: String) async throws -> Data {
    guard let url = URL(string: urlString) else {
      throw ImageConversionError.invalidURL
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    guard let image = UIImage(data: data),
          let imageData = image.jpegData(compressionQuality: 0.2) else {
      throw ImageConversionError.imageConversionFailed
    }
    
    return imageData
  }
}

// Usage Example
//Task {
//    do {
//        let imageData = try await ImageConverter.convertImageURLToData("https://example.com/image.png")
//        print("Image data size: \(imageData.count) bytes")
//        // 여기서 SwiftData 등에 저장 가능
//    } catch {
//        print("Error: \(error)")
//    }
//}
