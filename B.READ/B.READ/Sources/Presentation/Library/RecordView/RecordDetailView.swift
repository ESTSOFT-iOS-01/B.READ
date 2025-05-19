//
//  RecordDetailView.swift
//  B.READ
//
//  Created by 심근웅 on 5/18/25.
//

import SwiftUI

// MARK: - (S)RecordDetailView
struct RecordDetailView: View {
  
  @ObservedObject var viewModel: RecordDetailViewModel
  
  @State var showDeleteAlert: Bool = false
  @Environment(\.dismiss) var dismiss
  
  
  var body: some View {
    ScrollView(.vertical) {
      DetailView
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 24)
        .padding(.horizontal, 24)
    } // : ScrollView
    .background(.backgroundDefault)
    .navigationBarBackButtonHidden(true) // 기본 뒤로가기 버튼 숨김
    .toolbar {
      // 뒤로가기 버튼
      ToolbarItem(placement: .topBarLeading) {
        BackButton
      }
      
      ToolbarItem(placement: .topBarTrailing) {
        HStack(spacing: 0) {
          Button {
            viewModel.send(.onTapFavorite)
          } label: {
            Image(systemName: viewModel.record.isFavorite ? "bookmark.fill" : "bookmark")
          }
          Button {
            showDeleteAlert = true
          } label: {
            Text("삭제")
              .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.4)
          }
        } // HStack
        .foregroundColor(.green6)
      } // : ToolbarItem
    } // : .toolBar
    .alert("기록삭제", isPresented: $showDeleteAlert) {
      // TODO: - 삭제 alert뷰 구성
      Button("삭제", role: .destructive) {
        // TODO: - (2)삭제 로직 구현
        viewModel.send(.onTapDelete)
        dismiss()
      }
      Button("취소", role: .cancel) { }
    }
    .onAppear {
      viewModel.send(.onAppear)
    }
  }
  
  // MARK: - (S)BackButton
  private var BackButton: some View {
    Button(action: {
      dismiss()
    }) {
      Image(systemName: LibraryConstants.Icon.back)
        .foregroundColor(.green6) // ← 원하는 색상 지정
        .imageScale(.large)
    }
  }
  
  // MARK: - (S)DetailView
  private var DetailView: some View {
    VStack {
      Rectangle()
        .fill(.blue.opacity(0.3))
        .frame(width: 176, height: 284)
        .cornerRadius(6)
      Text("텍스트")
      // TODO: - 여기서 부터 책제목 들어감
    } // : VStack
  }
}

#Preview {
  let record = DummyData.dummyRecords[0]
  RecordDetailView(viewModel: RecordDetailViewModel(record: record))
}
