//
//  RecordDetailView.swift
//  B.READ
//
//  Created by 심근웅 on 5/18/25.
//

import SwiftUI

// MARK: - (S)RecordDetailView
struct RecordDetailView: View {
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  @StateObject var viewModel: RecordDetailViewModel
  
  @State var showSortMenu: Bool = false
  @State var showDeleteAlert: Bool = false
  @State var showRecordMenuActionSheet: Bool = false
  
  private let layoutPadding: CGFloat = 16
  private let floatingButtonPadding: CGFloat = 32

  // MARK: - Init
  init(viewModel: @autoclosure @escaping () -> RecordDetailViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel())
  }
  
  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      ScrollView {
        VStack(alignment: .trailing, spacing: layoutPadding) {
          // 표지, 제목, 작가
          RecordBookSection(record: $viewModel.record)
          
          // 기대지수(평점), 독서기간, 독서량
          RecordStatsSection(record: $viewModel.record)
            .padding(.top, 8)
          
          // 메모, 문장 탭바
          TopTabBar(
            tabs: [TabItem(title: "메모"), TabItem(title: "문장")],
            selectedIndex: $viewModel.selectedTab
          )
          .frame(height: 34)
          .padding(.top, 8)
          
          // 정렬 버튼
          SortMenuButton(
            isOpened: $showSortMenu,
            selectedOption: $viewModel.selectedSort[viewModel.selectedTab]
          )
          .padding(.trailing, 8)
          
          // 메모, 문장 리스트
          RecordNotesSection(viewModel: viewModel)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
          
        } // : VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, layoutPadding)
        
        
      } // : ScrollView
      .scrollIndicators(.never)
      
      if showSortMenu {
        Color.black.opacity(0.2)
          .ignoresSafeArea()
          .zIndex(2)
          .onTapGesture {
            showSortMenu = false
          }
      }
      
      if !showSortMenu {
        // 플로팅 버튼
        Button {
          showRecordMenuActionSheet = true
        } label: {
          Image(systemName: "plus")
            .font(.system(size: 26))
            .frame(width: 64, height: 64)
            .foregroundStyle(.orange3)
        }
        .zIndex(1)
        .background(
          Circle()
            .fill(Color.backgroundDefault)
            .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
        )
        .padding(.trailing, floatingButtonPadding)
        .padding(.bottom, floatingButtonPadding)
      }
    } // : ZStack
    .background(.backgroundDefault)
    .toolbar {
      // 즐겨찾기, 삭제 버튼
      ToolbarItem(placement: .topBarTrailing) {
        topBarTrailingButton()
      }
    } // : toolBar
    .alert("독서 기록 삭제", isPresented: $showDeleteAlert) {
      Button("삭제", role: .destructive) {
        viewModel.send(.onTapDelete)
        coordinator.pop()
      }
      Button("취소", role: .cancel) { }
    } message: {
      Text("정말로 독서 기록을 삭제하시겠습니까?")
    } // : alert
    .onAppear {
      print("DetailView OnAppear")
      viewModel.send(.onAppear)
    } // : onAppear
    .confirmationDialog("독서 기록 메뉴", isPresented: $showRecordMenuActionSheet) {
      Button("독서 기록") {
        print("독서 기록 수정 선택")
      }
      Button("메모 작성") {
        guard let record = viewModel.record else { return }
        coordinator.push(.memo(record: record, totalPage: record.totalPage))
      }
      Button("문장 작성") {
        guard let record = viewModel.record else { return }
        coordinator.push(.sentenceInput(mode: .create(record: record)))
      }
      Button("취소", role: .cancel) { }
    }
  }
  
  
  // MARK: - (F)topBarTrailingButton
  private func topBarTrailingButton() -> some View {
    HStack(spacing: 0) {
      // 즐겨찾기 버튼
      Button {
        viewModel.send(.onTapFavorite)
      } label: {
        if let isFavorite = viewModel.record?.isFavorite {
          Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
        } else {
          Image(systemName: "bookmark")
        }
      }
      // 삭제 버튼
      Button {
        showDeleteAlert = true
      } label: {
        Text("삭제")
          .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.4)
      }
    } // : HStack
    .foregroundColor(.green6)
  }
}

#Preview {
  let recordID = DummyData.dummyRecords[2].id
  PreviewableContainer {
    RecordDetailView(viewModel: .init(recordID: recordID))
  }
}
