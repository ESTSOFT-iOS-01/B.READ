//
//  ScanView.swift
//  B.READ
//
//  Created by 김도연 on 5/20/25.
//

import SwiftUI

// MARK: - (S)ScanView
struct ScanView: View {
  @StateObject var viewModel: ScanViewModel
  @EnvironmentObject var coordinator: Coordinator<MainRoute>
  
  init(viewModel: ScanViewModel) {
    self._viewModel = .init(wrappedValue: viewModel)
  }

  var body: some View {
    VStack {
      CustomCameraRepresentable(isbnNumber: $viewModel.isbnNumber, noCamera: $viewModel.noCamera)
      
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
    .onChange(of: viewModel.isbnNumber, { oldValue, newValue in
      if oldValue != newValue && !newValue.isEmpty {
        coordinator.push(.searchBook(isbn: viewModel.isbnNumber))
      }
    })
    .alert("경고", isPresented: $viewModel.noCamera) {
      Button("직접 검색하기", role: .cancel) {
        coordinator.pop()
      }
    } message: {
      Text("카메라를 사용할 수 없습니다.")
    }
    .toolbar(.hidden) // 하단 탭바 안보이게 처리?
    .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
    
  }
}

//#Preview {
//  ScanView()
//}

