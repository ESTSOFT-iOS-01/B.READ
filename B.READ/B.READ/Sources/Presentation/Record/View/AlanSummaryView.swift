//
//  AlanSummaryView.swift
//  B.READ
//
//  Created by 김도연 on 6/1/25.
//

import SwiftUI

struct AlanSummaryView: View {
  @StateObject var viewModel: SummaryViewModel
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  
  init(viewModel: @autoclosure @escaping () ->  SummaryViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel())
  }
  
  var body: some View {
    Group {
      switch viewModel.dataState {
      case .loading:
        LoadingView(text: "요약노트 작성 중...")
      case .loaded:
        ScrollView {
          VStack(alignment: .center, spacing: 12) {
            if let startDate = viewModel.record.period.0,
               let endDate = viewModel.record.period.1 {
              InfoView(title: "🗓️ 독서 기간", content: "\(startDate) ~ \(endDate)")
            }
            
            if let summary = viewModel.summary {
              InfoView(title: "🏷️ 감정 태그", content: "")
              InfoView(title: "📚 요약", content: summary.content)
            }
            
            MultiInfoView(title: "🍞 문장", content: viewModel.quoteData)
            
            MultiInfoView(title: "📝 메모", content: viewModel.memoData)
          }
        }
      case .failed:
        FailedView(desp: "빵식이가 요약노트를 생성할 수 없습니다.")
      }
    }
    .navigationTitle(viewModel.record.title)
    .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
  }
}

#Preview {
  let recordDetail = RecordDetailVO(record: DummyData.dummyRecords[1], book: DummyData.dummyBooks[1])
  
  AlanSummaryView(viewModel: .init(
    record: RecordDetailVO(record: DummyData.dummyRecords[1], book: DummyData.dummyBooks[1]),
    memos: DummyData.dummyMemos.map{ MemoVO($0, record: recordDetail) },
    quotes: DummyData.dummyQuote.map{ QuoteVO($0, record: recordDetail) })
  )
  
}
