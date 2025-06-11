//
//  LoadingView.swift
//  B.READ
//
//  Created by 김도연 on 6/4/25.
//

import SwiftUI

struct LoadingView: View {
  @State private var scale: CGFloat = 1.0
  let text: String?
  
  init(text: String? = nil) {
    self.text = text
  }

  var body: some View {
    VStack {
      Image(.loadingBread)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 60, height: 60)
        .scaleEffect(scale)
        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: scale)
        .onAppear {
          scale = 1.2
        }
      
      Text(text ?? "데이터 불러오는 중...")
        .brStyleFont(.pretendard(.regular, size: text == nil ? 16 : 12), lineHeight: 1.2)
        .foregroundColor(.brown7)
        .padding(.top, 16)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    //.background(.backgroundDefault)
    .ignoresSafeArea()
  }
}

#Preview {
  LoadingView()
}

struct FailedView: View {
  var title: String = "😢 정보를 불러오는 데 실패했어요."
  var error: Error? = nil
  var desp: String? = nil
  
  var body: some View {
    VStack(spacing: 16) {
      Text(title)
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1, letterSpacing: -0.02)
        .foregroundStyle(.brown9)
      
      Group {
        if let error = error {
          Text(error.localizedDescription)
        }
        if let desp = desp {
          Text(desp)
        }
      }
      .brStyleFont(.pretendard(.light, size: 14), lineHeight: 1, letterSpacing: -0.02)
      .foregroundColor(.gray7)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
  }
}
