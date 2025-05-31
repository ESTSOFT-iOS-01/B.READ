//
//  ImageConverter.swift
//  B.READ
//
//  Created by 김도연 on 5/31/25.
//

import Foundation
import UIKit

enum ImageConverter {
  /// 이미지 URL 문자열을 `Data`로 변환하는 중 발생할 수 있는 에러 유형.
  enum ImageConversionError: Error {
    case invalidURL
    case downloadFailed
    case imageConversionFailed
  }
  
  /// 이미지 URL 문자열을 JPEG `Data`로 변환합니다.
  ///
  /// - Parameter urlString: 이미지 URL 문자열
  /// - Returns: 압축된 JPEG 이미지 데이터
  /// - Throws: URL이 유효하지 않거나 이미지 변환 실패 시 오류를 발생시킵니다.
  static func convertImageURLToData(_ urlString: String) async throws -> Data {
    guard let url = URL(string: urlString) else {
      throw ImageConversionError.invalidURL
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    guard let image = UIImage(data: data),
          let imageData = image.jpegData(compressionQuality: 0.5) else {
      throw ImageConversionError.imageConversionFailed
    }
    
    return imageData
  }
}


// 사용 예시
//Task {
//    do {
//        let imageData = try await ImageConverter.convertImageURLToData("https://image.aladin.co.kr/product/9871/8/cover500/k042535550_2.jpg")
//        print("Image data size: \(imageData.count) bytes")
//        
//        // 예: SwiftData 모델 등에 저장 가능
//        // book.coverImageData = imageData
//
//    } catch {
//        print("이미지 변환 실패: \(error.localizedDescription)")
//    }
//}

