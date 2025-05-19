//
//  RecordDetailView.swift
//  B.READ
//
//  Created by 심근웅 on 5/18/25.
//

import SwiftUI

// MARK: - (S)RecordDetailView
struct RecordDetailView: View {
  
  @Environment(\.dismiss) var dismiss
  
  @Binding var record: Record
  @State var showDeleteAlert: Bool = false

  var body: some View {
    ScrollView(.vertical) {
      DetailView()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 24)
        .padding(.horizontal, 24)
    } // : VStack
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(true) // 기본 뒤로가기 버튼 숨김
    .toolbar {
      // 뒤로가기 버튼
      ToolbarItem(placement: .topBarLeading) {
        BackButton()
      }
      
      ToolbarItem(placement: .topBarTrailing) {
        HStack(spacing: 0) {
          Button {
            print("즐겨찾기 버튼 클릭")
//            self.isFavorite.toggle()
          } label: {
//            Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
            Image(systemName: "bookmark")
          }
          Button {
            print("삭제 버큰 클릭")
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
        print("삭제 진행")
        // TODO: - (2)삭제 로직 구현
        dismiss()
      }
      Button("취소", role: .cancel) { }
    }
  }
}

// MARK: - (S)BackButton
struct BackButton: View {
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    Button(action: {
      dismiss()
    }) {
      Image(systemName: "chevron.left")
        .foregroundColor(.green6) // ← 원하는 색상 지정
        .imageScale(.large)
    }
  }
}

// MARK: - (S)DetailView
struct DetailView: View {
  var body: some View {
    VStack {
      Rectangle()
        .fill(.blue.opacity(0.3))
        .frame(width: 176, height: 284)
        .cornerRadius(6)
      
      // TODO: - 여기서 부터 책제목 들어감
    } // : VStack
  }
}
//
//#Preview {
//  @Previewable @State var isFavorite = true
////  RecordDetailView(isFavorite: $isFavorite)
//  LibraryView(isFavorite: isFavorite)
//}
