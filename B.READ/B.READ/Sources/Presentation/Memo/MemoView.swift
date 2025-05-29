//
//  MemoView.swift
//  B.READ
//
//  Created by 신승재 on 5/25/25.
//

import SwiftUI

struct MemoView: View {
  
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  @State private var startPage: String = ""
  @State private var endPage: String = ""
  @State private var memoText: String = "memo"
  
  private var isButtonEnabled: Bool {
    !startPage.isEmpty && !endPage.isEmpty && !memoText.isEmpty
  }
  
  let targetDate: Date
  let totalPage: Int
  
  private let guideText = """
  여기를 터치해서
  빵식이가 제안하는
  질문을 볼 수 있어요
  """
  
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      
      guideSection()
      
      pageSection()
      
      memoSection()
      
    }
    .navigationTitle(targetDate.string(format: .dotSeparatedFull))
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(.horizontal, 24)
    .background(.backgroundDefault)
    .onChange(of: startPage) {
      startPage = formatDigits($1)
    }
    .onChange(of: endPage) {
      endPage = formatDigits($1)
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          coordinator.pop()
        } label: {
          Text("저장")
            .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.0)
            .foregroundStyle(.green6)
            .opacity(isButtonEnabled ? 1 : 0)
            .disabled(!isButtonEnabled)
            .animation(.easeInOut(duration: 0.2), value: isButtonEnabled)
        }
      }
    }
  }
  
  private func formatDigits(_ input: String) -> String {
    let filtered = input.filter { $0.isNumber }
    if filtered.hasPrefix("0"), filtered.count >= 1 {
      return String(filtered.drop(while: { $0 == "0" }))
    }
    return filtered
  }
  
  // MARK: (F)guideSection
  @ViewBuilder
  private func guideSection() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("빵식이의 가이드")
          .foregroundStyle(.black)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.2)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Image(systemName: "trash")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 16, height: 16)
          .foregroundStyle(.gray2)
      }
      
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
    }.padding(.top, 24)
  }
  
  // MARK: (F)pageSection
  @ViewBuilder
  private func pageSection() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("페이지")
        .foregroundStyle(.black)
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.2)
      
      HStack {
        RoundedTextField(type: .pages, placeholder: "0", text: $startPage, isValid: true)
        
        Text("~")
        
        RoundedTextField(type: .pages, placeholder: "0", text: $endPage, isValid: true)
        
        Text("쪽")
      }.padding(.trailing, 52)
    }
  }
  
  // MARK: (F)memoSection
  @ViewBuilder
  private func memoSection() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("메모 내용을 작성해주세요")
        .foregroundStyle(.black)
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.2)
      
     // TODO: 텍스트 에디터 들어오면 넣기
    }
  }
}

#Preview {
  NavigationStack {
    MemoView(targetDate: .now, totalPage: 200)
  }
}
