//
//  StringProtocol.swift
//  B.READ
//
//  Created by 심근웅 on 6/8/25.
//

import Foundation
import SwiftUI

extension StringProtocol {
  /// 키워드가 포함되는 Index 범위를 찾습니다.
  ///
  /// - Parameter keyword: String중 찾을 키워드
  /// - Returns: 키워드가 일치하는 Index범위 배열
  func allRanges(of keyword: String) -> [Range<Index>] {
    guard !keyword.isEmpty else { return [] }
    
    var ranges: [Range<Index>] = []
    var start = startIndex
    
    while start < endIndex {
      // 현재 위치부터 키워드 길이만큼의 범위 설정
      guard let end = index(start, offsetBy: keyword.count, limitedBy: endIndex) else {
        break
      }
      let candidate = self[start..<end]
      
      // 키워드와 일치하면(대소문자 무시) 결과에 추가
      if candidate.lowercased() == keyword.lowercased() {
        ranges.append(start..<end)
        start = end
      } else {
        // 다음 문자로 이동
        start = index(after: start)
      }
    }
    
    return ranges
  }
}

extension StringProtocol {
  /// 문자열에서 키워드를 하이라이트 처리합니다.
  ///
  /// - Parameter
  ///  - `keyword`: 하이라이트할 String
  ///  - `highlightColor`: 적용할 하이라이트 색상 (기본값은 `.orange4`)
  ///  - `regularFont`: 일반 텍스트에 들어갈 폰트 (기본값은 regular, 16)
  ///  - `highlightFont`: 하이라이트 텍스트에 들어갈 폰트 (기본값은 bold, 16)
  /// - Returns: 키워드에 highlightColor가 적용된 Text
  func highlightedText(
    keyword: String,
    highlightColor: Color = .orange4,
    regularFont: Font = Font(UIFont.pretendard(.regular, size: 16)),
    highlightFont: Font = Font(UIFont.pretendard(.bold, size: 16))
  ) -> Text {
    // 1. 키워드가 비어있으면 원본문자열을 반환
    guard !keyword.isEmpty else {
      return Text(String(self))
        .font(regularFont)
        .foregroundColor(.black)
    }
    
    // 대소문자 구분하지 않음
    let keyword = keyword.lowercased()
    // 2. 모든 일치하는 범위를 찾음 (겹치는 범위도 포함)
    let ranges = self.allRanges(of: keyword)
    
    // 3. 일치하는 부분이 없으면 원본문자열 반환
    guard !ranges.isEmpty else {
      return Text(String(self))
        .font(regularFont)
        .foregroundColor(.black)
    }
    
    var result = Text("")
    var currentIndex = self.startIndex
    
    // 4. 각 범위를 순회하며 하이라이트 적용
    for range in ranges {
      // 4-1. 일반 텍스트
      if currentIndex < range.lowerBound {
        result = result + Text(String(self[currentIndex..<range.lowerBound]))
          .font(regularFont)
          .foregroundColor(.black)
      }
      
      // 4-2. 하이라이트 텍스트
      result = result + Text(String(self[range]))
        .font(highlightFont)
        .foregroundColor(highlightColor)
      
      // 4-3. 다음 인덱스로 이동
      currentIndex = range.upperBound
    }
    
    // 5. 남은 텍스트 처리
    if currentIndex < endIndex {
      result = result + Text(String(self[currentIndex..<endIndex]))
        .font(regularFont)
        .foregroundColor(.black)
    }
    
    return result
  }
}
