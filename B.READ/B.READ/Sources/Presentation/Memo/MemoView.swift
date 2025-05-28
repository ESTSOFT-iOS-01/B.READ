//
//  MemoView.swift
//  B.READ
//
//  Created by 신승재 on 5/25/25.
//

import SwiftUI

struct MemoView: View {
  
  let targetDate: Date
  let guideText = """
  여기를 터치해서
  빵식이가 제안하는
  질문을 볼 수 있어요
  """
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("빵식이의 가이드")
        .foregroundStyle(.black)
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.2)
      
      HStack(spacing: 40) {
        Image(.happyBread)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 100)
        
        Text(guideText)
          .foregroundStyle(.gray5)
          .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.4, letterSpacing: -0.025)
          .frame(maxWidth: .infinity, alignment: .leading)
          
      }
      .padding(.vertical, 25)
      .padding(.horizontal, 37)
      .frame(maxWidth: .infinity)
      .background(.green1)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .padding(.top, 8)
      
      Text("페이지")
        .foregroundStyle(.black)
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.2)
        .padding(.top, 24)
      
      Text("메모 내용을 작성해주세요")
        .foregroundStyle(.black)
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.2)
        .padding(.top, 24)
    }
    .navigationTitle(targetDate.string(format: .dotSeparatedFull))
    .padding(.horizontal, 24)
  }
}

#Preview {
  MemoView(targetDate: .now)
}
