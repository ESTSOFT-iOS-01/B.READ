//
//  LoadingView.swift
//  B.READ
//
//  Created by 김도연 on 6/4/25.
//

import SwiftUI

struct LoadingView: View {
  var body: some View {
    ProgressView("데이터 불러오는 중...")
      .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
  }
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

#Preview {
  LoadingView()
}
