//
//  RecordStatsSection.swift
//  B.READ
//
//  Created by 심근웅 on 5/23/25.
//

import SwiftUI

// MARK: - (S)RecordStatsSection
struct RecordStatsSection: View {
  @ObservedObject var viewModel: RecordDetailViewModel
  @EnvironmentObject private var coordinator: Coordinator<MainRoute, SheetRoute>
  @State private var showSummaryAlert: Bool = false
  
  private let contentHeaderFontSize: CGFloat = 16
  private let contentFontSize: CGFloat = 14
  private let layoutPadding: CGFloat = 8
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      // 기대 지수, 평점
      if viewModel.record?.readingState == .notStart {
        VStack(alignment: .leading, spacing: 8) {
          Text("기대지수")
          ScoreBoardView(viewModel.record?.heart ?? 0, type: .heart)
        }
        .brStyleFont(.pretendard(.semiBold, size: contentHeaderFontSize), lineHeight: 0.95)
      } else if let record = viewModel.record, record.readingState == .finished {
        HStack {
          VStack(alignment: .leading, spacing: 8) {
            Text("평점")
            ScoreBoardView(record.star, type: .star)
          } // : VStack
          .brStyleFont(.pretendard(.semiBold, size: contentHeaderFontSize), lineHeight: 0.95)
          .frame(maxWidth: .infinity, alignment: .leading)
          
          
          if !viewModel.memos.isEmpty {
            Button {
              if let summaryData = viewModel.summary {
                coordinator.push(
                  .summaryDetail(
                    id: summaryData.id,
                    record: viewModel.record!,
                    memos: viewModel.memos,
                    quotes: viewModel.quotes
                  )
                )
              } else {
                showSummaryAlert = true
              }
            } label: {
              Image(.breadButton)
                .resizable()
                .aspectRatio(contentMode: .fit)
            }
            .frame(width: 48, height: 48)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 16)
          }
        } // : HStack
        .frame(maxWidth: .infinity)
        
        recordReview()
      }
      
      // 독서 기간
      VStack(alignment: .leading, spacing: layoutPadding) {
        Text("독서 기간")
          .brStyleFont(
            .pretendard(.semiBold, size: contentHeaderFontSize),
            lineHeight: 0.95
          )
        
        recordPeriodView()
          .frame(height: 38)
          .background(.gray0)
          .cornerRadius(8)
      } // : VStack
      
      // 독서 진행률 프로그래스바
      if viewModel.record?.readingState != .finished,
         let currentPage = viewModel.record?.currentPage,
         let totalPage = viewModel.record?.totalPage
      {
        PageProgressbar(currentPage: currentPage, totalPage: totalPage)
          .frame(height: 28)
      }
    } // : VStack
    .alert("요약 노트 생성", isPresented: $showSummaryAlert) {
      Button("취소", role: .cancel) { }
      Button("생성") {
        coordinator.push(
          .createSummary(
            record: viewModel.record!,
            memos: viewModel.memos,
            quotes: viewModel.quotes
          )
        )
      }
    } message: {
      Text("빵식이의 요약노트를 생성할까요?")
    } // : alert
  }
  
  // MARK: - (F)recordPeriodView
  @ViewBuilder
  private func recordPeriodView() -> some View {
    HStack(spacing: layoutPadding) {
      if let period = viewModel.record?.period, let startDate = period.startDate {
        HStack(spacing: layoutPadding) {
          Text("시작")
            .brStyleFont(
              .pretendard(.semiBold, size: contentFontSize),
              lineHeight: 1.3
            )
            .foregroundStyle(.green4)
          Text(startDate.string(format: .dotSeparated))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.gray2)
            .brStyleFont(
              .pretendard(.regular, size: contentFontSize),
              lineHeight: 1.3,
              letterSpacing: -0.025
            )
          if let endDate = period.endDate {
            Text("종료")
              .brStyleFont(
                .pretendard(.semiBold, size: contentFontSize),
                lineHeight: 1.3
              )
              .foregroundStyle(.green4)
            Text(endDate.string(format: .dotSeparated))
              .frame(maxWidth: .infinity, alignment: .leading)
              .foregroundStyle(.gray2)
              .brStyleFont(
                .pretendard(.regular, size: contentFontSize),
                lineHeight: 1.3,
                letterSpacing: -0.025
              )
          }
        }
      } else {
        Text("아직 독서를 시작하지 않았어요")
          .brStyleFont(
            .pretendard(.semiBold, size: contentFontSize),
            lineHeight: 1.3
          )
          .foregroundStyle(.green4)
      }
    } // : HStack
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, layoutPadding)
    .padding(.horizontal, 16)
  }
  
  // MARK: - (F)recordReview
  private func recordReview() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("한줄평")
        .brStyleFont(.pretendard(.semiBold, size: contentHeaderFontSize), lineHeight: 0.95)
      
      ZStack(alignment: .topLeading) {
        RoundedRectangle(cornerRadius: 8)
          .fill(.gray0)
        
        if let review = viewModel.record?.review, !review.isEmpty {
          Text(review)
            .brStyleFont(.pretendard(.regular, size: contentFontSize), lineHeight: 1.3)
            .padding(16)
        } else {
          Text("짧은 감상평을 남겨보세요")
            .brStyleFont(.pretendard(.regular, size: contentFontSize), lineHeight: 1.3)
            .foregroundStyle(.gray5)
            .padding(16)
        }
      } // : ZStack
    } // : VStack
  }
}

#Preview {
  let recordID = DummyData.dummyRecords[2].id
  PreviewableContainer {
    NavigationStack {
      RecordDetailView(viewModel: .init(recordID: recordID))
        .environmentObject(Coordinator<MainRoute, SheetRoute>())
    }
  }
}
