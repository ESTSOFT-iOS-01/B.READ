//
//  ScanView.swift
//  B.READ
//
//  Created by 김도연 on 5/20/25.
//

import SwiftUI

struct ScanView: View {
  @State private var isbnNumber: String = ""
  
    var body: some View {
      NavigationStack {
        VStack {
          BarcodeScannerView(isbnNumber: $isbnNumber)
            .frame(height: 400, alignment: .top)
            .frame(maxWidth: .infinity)
            .padding(.top, 16)
          
          Text("빵식이가 빠르게 책을 찾을 수 있도록\n책의 ISBN 바코드를 정확히 스캔해주세요!")
            .brStyleFont(.pretendard(.semiBold, size: 16), lineHeight: 1.2, letterSpacing: 0.02)
            .multilineTextAlignment(.center)
            .foregroundStyle(.brown5)
            .frame(alignment: .center)
            .padding(.top, 32)
          
          VStack(spacing: 8) {
            Text("ISBN 예시")
              .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.2, letterSpacing: -0.01)
              .foregroundStyle(.brown8)
              .frame(alignment: .center)
              .padding(.top, 4)
              
            Image(SearchConstants.Image.isbnEx)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 200, alignment: .center)
              .padding(.horizontal, 8)
          }
          .border(.brown5)
          .padding(.top, 20)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("ISBN 바코드 스캔")
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
      }
      .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
    }
}

#Preview {
    ScanView()
}

