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
    ScrollView {
      VStack(alignment: .center, spacing: 12) {
        InfoView(title: "🗓️ 독서 기간", content: "~ 2025. 06. 06")
        
        InfoView(title: "🏷️ 감정 태그", content: "")
        
        InfoView(title: "📚 요약", content: viewModel.summary.content)
        
        MultiInfoView(title: "🍞 문장", content: viewModel.quoteData)
        
        MultiInfoView(title: "📝 메모", content: viewModel.memoData)
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

