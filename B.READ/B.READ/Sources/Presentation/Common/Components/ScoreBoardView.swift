//
//  ScoreBoardView.swift
//  B.READ
//
//  Created by 심근웅 on 5/23/25.
//

import SwiftUI

// MARK: - (S)ScoreBoardView
struct ScoreBoardView: View {
  
  enum ScoreType {
    case heart
    case star
    
    var image: Image {
      switch self {
      case .heart: Image(systemName: "heart.fill")
      case .star: Image(systemName: "star.fill")
      }
    }
  }
  
  // MARK: - State
  @Binding private var bindingScore: Int
  private let fixedScore: Int
  private let type: ScoreType
  private let maxScore: Int
  private let isInteractive: Bool
  
  
  // MARK: - Init
  init(_ score: Binding<Int>, type: ScoreType, maxScore: Int = 5) {
    self._bindingScore = score
    self.fixedScore = score.wrappedValue
    self.type = type
    self.maxScore = maxScore
    self.isInteractive = true
  }
  
  init(_ score: Int, type: ScoreType, maxScore: Int = 5) {
    self._bindingScore = .constant(score)
    self.fixedScore = score
    self.type = type
    self.maxScore = maxScore
    self.isInteractive = false
  }
  
  private var displayedScore: Int {
    isInteractive ? bindingScore : fixedScore
  }
  
  var body: some View {
    HStack(spacing: 8) {
      ForEach(1...maxScore, id: \.self) { index in
        type.image
          .resizable()
          .frame(width: 18, height: 18)
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(index <= displayedScore ? .orange7 : .gray1)
          .contentShape(Rectangle()) // 터치 판정 영역 확대
          .onTapGesture {
            if isInteractive {
              if bindingScore == index {
                bindingScore = 0
              }
              else {
                bindingScore = index
              }
            }
          } // : onTapGesture
      } // : ForEach
    } // : HStack
  }
}


#Preview {
  @Previewable @State var bindingScore = 3
  let fixedScore = 3
  VStack(spacing: 16) {
    ScoreBoardView(fixedScore, type: .star)
    ScoreBoardView($bindingScore, type: .heart)
  }
  .background(.backgroundDefault)
}
