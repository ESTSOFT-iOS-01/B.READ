//
//  RecordDetailView.swift
//  B.READ
//
//  Created by 심근웅 on 5/18/25.
//

import SwiftUI

// MARK: - (S)RecordDetailView
struct RecordDetailView: View {
  
  // TODO: - Usecase 연결 후, ObservedObject로 변경
  @StateObject var viewModel: RecordDetailViewModel
  
  @State var showDeleteAlert: Bool = false
  @Environment(\.dismiss) var dismiss
  
  private let layoutPadding: CGFloat = 24
  
  // MARK: - Init
  init(viewModel: @autoclosure @escaping () -> RecordDetailViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel())
    // 24615번 줄
  }
  
  var body: some View {
    // TODO: - ZStack으로 플로팅 버튼 만들기 -> 액션 시트?
    ScrollView(.vertical) {
      VStack(spacing: layoutPadding) {
        // MARK: -  내부 뷰를 하위뷰로 빼서 만들어도 좋을 듯
        // 표지
        covorImage
          .padding(.top, layoutPadding)
        
        // 제목, 작가
        bookTitleSection
        
        // 기대지수(평점), 독서기간, 독서량
        recordStatsSection
        
        // 메모, 문장 탭바
        TopTabBar(
          tabs: [TabItem(title: "메모"), TabItem(title: "문장")],
          selectedIndex: $viewModel.state.selectedTab
        )
        .onChange(of: viewModel.state.selectedTab) {
          viewModel.send(.onAppear)
        }
        
        // 메모, 문장 리스트
        recordNotesSection
        
      } // : VStack
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .padding(.horizontal, layoutPadding)
      
    } // : ScrollView
    .background(.backgroundDefault)
    .navigationBarBackButtonHidden(true) // 기본 뒤로가기 버튼 숨김
    .onAppear {
      print("DetailView OnAppear")
      viewModel.send(.onAppear)
    } // : onAppear
    .toolbar {
      // 뒤로가기 버튼
      ToolbarItem(placement: .topBarLeading) {
        Button {
          dismiss()
        } label: {
          Image(systemName: LibraryConstants.Icon.back)
            .foregroundColor(.green6)
        }
      }
      
      ToolbarItem(placement: .topBarTrailing) {
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
    } // : toolBar
    .alert("독서 기록 삭제", isPresented: $showDeleteAlert) {
      Button("삭제", role: .destructive) {
        viewModel.send(.onTapDelete)
        dismiss()
      }
      Button("취소", role: .cancel) { }
    } message: {
      Text("정말로 독서 기록을 삭제하시겠습니까?")
    } // : alert
  }
  
  // MARK: - (S)covorImage
  private var covorImage: some View {
    Group {
      if let imageData = viewModel.state.info?.book.coverImage,
         let image = UIImage(data: imageData) {
        Image(uiImage: image)
          .resizable()
      } else {
        // TODO: - 사진이 없을때, 들어갈 이미지 or 도형 추가
        Rectangle()
          .fill(.red.opacity(0.2))
      }
    } // : Group
    .frame(width: 176, height: 284)
    .cornerRadius(6)
  }
  
  // MARK: - (S)bookTitleSection
  private var bookTitleSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(viewModel.state.info?.book.name ?? "제목")
        .brStyleFont(.pretendard(.semiBold, size: 24), lineHeight: 1)
        .lineLimit(1)
      
      // FIXME: - 확인해보고 weight, size 수정해야할듯 - light는 괜찮은듯 한데, size 12가 너무 작은듯
      Text(viewModel.state.info?.book.author ?? "작가")
        .brStyleFont(.pretendard(.light, size: 12), lineHeight: 1)
        .lineLimit(1)
        .foregroundStyle(.gray3)
      
    } // : VStack
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
  }
  
  // MARK: - (S)recordStatsSection
  private var recordStatsSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      // 기대 지수, 평점
      // TODO: - 기대 지수, 평점 점수판 만들어서 넣기
      Group {
        if let record = viewModel.state.info?.record {
          switch record.state {
          case .toRead:
            Text("기대지수")
          case .reading:
            EmptyView()
          case .completed:
            Text("평점")
          }
        } else {
          Text("정보를 찾을 수 없습니다.")
        }
      } // : Group
      .brStyleFont(.pretendard(.semiBold, size: 16), lineHeight: 0.95)
      
      // 독서 기간
      VStack(alignment: .leading, spacing: 8) {
        Text("독서 기간")
          .brStyleFont(.pretendard(.semiBold, size: 14), lineHeight: 0.95)
        // TODO: - 독서 기간 컴포넌트 제작해서 넣기
//        recordPeriodView(start: viewModel.state.info?.record.period)
        Rectangle()
          .fill(.gray0)
          .frame(height: 38)
          .frame(maxWidth: .infinity)
          .cornerRadius(8)
      } // : VStack
      
      // 독서 진행률 프로그래스바
      if viewModel.state.info?.record.state != .completed,
         let currentPage = viewModel.state.info?.record.currentPage,
         let totalPage = viewModel.state.info?.book.totalPages {
        PageProgressbar(currentPage: currentPage, totalPage: totalPage)
          .frame(height: 28)
      }
    } // : VStack
  }
  
  // MARK: - (S)recordNotesSection
  // TODO: - 리스트 형태로 메모, 문장을 보여줌
  private var recordNotesSection: some View {
    VStack {
      
    }
  }
  
  // MARK: - (F)recordPeriodView
  // 독서 기간 뷰
  @ViewBuilder
  private func recordPeriodView() -> some View {
    
  }
}

#Preview {
  let record = DummyData.dummyRecords[0]
  let viewModel = RecordDetailViewModel(recordID: record.id, isbn: record.isbn)
//  RecordDetailView(viewModel: viewModel)
}
