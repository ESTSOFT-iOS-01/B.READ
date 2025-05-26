//
//  RecordMemoView.swift
//  B.READ
//
//  Created by 심근웅 on 5/26/25.
//

import SwiftUI

struct RecordMemoView: View {
  @StateObject var viewModel = RecordMemoViewModel()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      HStack {
        SearchBar(text: $viewModel.state.searchText, onSubmit: {
          if !viewModel.state.searchText.isEmpty {
            viewModel.send(.onSubmit)
          }
        }, style: .compact)
        
        sortButton()
      } // : HStack
      
      
      List {
        ForEach(viewModel.state.displaybooks.indices, id: \.self) { index in
          let book = viewModel.state.displaybooks[index]
          Section(book) {
            ForEach(viewModel.state.displayMemos[index]) { memo in
              Text(memo.content)
            }
          }
        }
      }
      
    } // : VStack
    .padding(.top, 24)
    .onAppear {
      viewModel.send(.onAppear)
    }
  }
  
  
  // MARK: - (F)sortButton
  // TODO: - (2)정렬 버튼 공통 컴포넌트로 제작 후, 컴포넌트로 변경
  // 예시) sortButton(type: .record)
  @ViewBuilder
  func sortButton() -> some View {
    Button {
      print("정렬 버튼 클릭")
    } label: {
      HStack {
        Text("정렬 기준")
        Image(systemName: LibraryConstants.Icon.menuOn)
          .resizable()
          .frame(width: 8, height: 3)
      } // : HStack
      .brStyleFont(.pretendard(.medium, size: 12), lineHeight: 1, letterSpacing: -0.02)
      .foregroundStyle(.gray2)
      .frame(width: 60, height: 36, alignment: .trailing)
    }
  }
}

#Preview {
  RecordMemoView()
    .padding(.horizontal, 24)
}
