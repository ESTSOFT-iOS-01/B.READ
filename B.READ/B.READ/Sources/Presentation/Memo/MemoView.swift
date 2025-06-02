//
//  MemoView.swift
//  B.READ
//
//  Created by 신승재 on 5/25/25.
//

import SwiftUI

struct MemoView: View {
  
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  @StateObject private var viewModel: MemoViewModel
  @State private var textEditorFocused: Bool = false
  @State private var showGuideAlert = false
  @State private var showErrorAlert = false
  
  private let totalPage: Int
  
  init(viewModel: MemoViewModel, totalPage: Int) {
    self._viewModel = .init(wrappedValue: viewModel)
    self.totalPage = totalPage
  }
  
  private var isButtonEnabled: Bool {
    !viewModel.startPage.isEmpty && !viewModel.endPage.isEmpty && !viewModel.content.isEmpty
  }
  
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
    .navigationTitle(viewModel.createAt.string(format: .dotSeparatedFull))
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(.horizontal, 24)
    .background(.backgroundDefault)
    .onChange(of: viewModel.startPage) {
      viewModel.startPage = formatDigits($1)
    }
    .onChange(of: viewModel.endPage) {
      viewModel.endPage = formatDigits($1)
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          let isValidPage = (viewModel.startPage <= viewModel.endPage) && (Int(viewModel.endPage) ?? 0 <= totalPage)
          if isValidPage {
            viewModel.send(.saveMemo)
            coordinator.pop()
          } else {
            showErrorAlert = true
          }
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
    .alert("가이드를 삭제하시겠습니까?", isPresented: $showGuideAlert) {
      Button("취소", role: .cancel) { }
      Button("삭제", role: .destructive) { viewModel.send(.deleteGuides) }
    } message: {
      Text("빵식이의 가이드를 삭제하시겠습니까?\n(다시 생성되지 않습니다)")
    }
    .alert("저장 실패", isPresented: $showErrorAlert){
      Button("확인", role: .cancel) { }
    } message: {
      Text("올바른 페이지 번호가 아닙니다.")
    }
  }
  
  // 숫자 외에 텍스트 필터링 및 0 못오게
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
        
        if !viewModel.guides.isEmpty {
          Image(systemName: "trash")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16)
            .foregroundStyle(.gray2)
            .onTapGesture {
              showGuideAlert = true
            }
        }
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
        RoundedTextField(type: .pages, placeholder: "0", text: $viewModel.startPage)
        
        Text("~")
        
        RoundedTextField(type: .pages, placeholder: "0", text: $viewModel.endPage)
        
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
      
      CustomTextEditor(
        text: $viewModel.content,
        isFocused: $textEditorFocused,
        placeholder: "여기를 터치해서 문장을 입력할 수 있어요"
      )
      .frame(height: 200)
      .tint(.gray9)
    }
  }
}

#Preview {
  PreviewableContainer {
    MemoView(viewModel: MemoViewModel(id: "exampleId"), totalPage: 300)
  }
}
