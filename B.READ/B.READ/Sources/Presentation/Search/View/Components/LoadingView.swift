//
//  LoadingView.swift
//  B.READ
//
//  Created by 김도연 on 6/4/25.
//

import SwiftUI

struct BouncingImageLoadingView: View {
  @State private var scale: CGFloat = 1.0

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
      
      Text("데이터 불러오는 중...")
        .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.2)
        .foregroundColor(.brown7)
        .padding(.top, 16)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .background(.backgroundDefault)
    .ignoresSafeArea()
  }
}

#Preview {
  BouncingImageLoadingView()
}

struct FailedView: View {
  var error: Error? = nil
  var desp: String? = nil
  
  var body: some View {
    VStack(spacing: 16) {
      Text("😢 정보를 불러오는 데 실패했어요.")
        .font(.headline)
        .foregroundStyle(.brown9)
      
      Group {
        if let error = error {
          Text(error.localizedDescription)
        }
        if let desp = desp {
          Text(desp)
        }
      }
      .font(.caption)
      .foregroundColor(.gray7)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
  }
}
