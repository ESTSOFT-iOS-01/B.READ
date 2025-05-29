//
//  RecordDetailView.swift
//  B.READ
//
//  Created by 심근웅 on 5/18/25.
//

import SwiftUI

// MARK: - (S)RecordDetailView
struct RecordDetailView: View {
  @EnvironmentObject var coordinator: Coordinator<MainRoute>
  @StateObject var viewModel: RecordDetailViewModel
  
  @State var showDeleteAlert: Bool = false
  @State var showRecordMenuActionSheet: Bool = false
  
  private let layoutPadding: CGFloat = 24
  private let floatingButtonPadding: CGFloat = 32
  
  // MARK: - Init
  init(viewModel: @autoclosure @escaping () -> RecordDetailViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel())
    // 24615번 줄
  }
  
  var body: some View {
    // TODO: - ZStack으로 플로팅 버튼 만들기 -> 액션 시트?
    ZStack(alignment: .bottomTrailing) {
      ScrollView(.vertical) {
        VStack(spacing: layoutPadding) {
          // 표지, 제목, 작가
          RecordBookSection(book: viewModel.state.info?.book)
            .padding(.top, layoutPadding)
          
          // 기대지수(평점), 독서기간, 독서량
          if let info = viewModel.state.info {
            RecordStatsSection(
              readState: info.record.state,
              period: (info.record.period.startDate, info.record.period.endDate),
              currentPage: info.record.currentPage,
              totalPage: info.book.totalPages,
              heartCount: info.record.heartCount,
              starCount: info.record.starCount
            )
          } else {
            Text("info 정보가 없습니다")
          }
          
          // 메모, 문장 탭바
          TopTabBar(
            tabs: [TabItem(title: "메모"), TabItem(title: "문장")],
            selectedIndex: $viewModel.state.selectedTab
          )
          
          // TODO: - 정렬 버튼 여기 들어감
          
          // 메모, 문장 리스트
          RecordNotesSection(viewModel: viewModel)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, layoutPadding)
          
        } // : VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, layoutPadding)
      } // : ScrollView
      
      Button {
        showRecordMenuActionSheet = true
      } label: {
        Image(systemName: "plus")
          .font(.system(size: 26))
          .frame(width: 64, height: 64)
          .foregroundStyle(.orange3)
      }
      .background(
        Circle()
          .fill(Color.backgroundDefault)
          .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
      )
      .padding(.trailing, floatingButtonPadding)
      .padding(.bottom, floatingButtonPadding)
    }
    .background(.backgroundDefault)
    .onAppear {
      print("DetailView OnAppear")
      viewModel.send(.onAppear)
    } // : onAppear
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
    .confirmationDialog("독서 기록 메뉴", isPresented: $showRecordMenuActionSheet) {
      Button("독서 기록") {
        print("독서 기록 수정 선택")
      }
      Button("메모 작성") {
        print("메모 작성 선택")
      }
      Button("문장 작성") {
        coordinator.push(.sentenceInput)
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
        if let isFavorite = viewModel.state.info?.record.isFavorite {
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
  RecordDetailView(viewModel: .init(
    recordID: DummyData.dummyRecords[2].id,
    isbn: DummyData.dummyRecords[2].isbn
  ))
}
