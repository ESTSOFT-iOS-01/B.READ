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
  
  var body: some View {
    ScrollView {
      VStack(alignment: .center, spacing: 12) {
        InfoView(title: "🗓️ 독서 기간", content: "2025. 06. 06 ~ 2025. 06. 06")
        
        InfoView(title: "🏷️ 감정 태그", content: "")
        
        InfoView(title: "📚 요약", content: text)
        
        MultiInfoView(title: "🍞 문장", content: [""])
        
        MultiInfoView(title: "📝 메모", content: [""])
      }
    }
    .navigationTitle(viewModel.record.title)
    .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
  }
}

#Preview {
  AlanSummaryView()
}

