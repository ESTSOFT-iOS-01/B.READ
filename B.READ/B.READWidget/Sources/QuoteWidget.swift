//
//  QuoteWidget.swift
//  B.READ
//
//  Created by 도민준 on 6/4/25.
//


import WidgetKit
import SwiftUI

@main
struct QuoteWidget: Widget {
  let kind: String = "QuoteWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: QuoteProvider()) { entry in
      QuoteWidgetView(entry: entry)
        .containerBackground(.backgroundDefault, for: .widget)
    }
    .configurationDisplayName("BREED 문장 위젯")
    .description("저장한 문장을 랜덤으로 표시합니다.")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}
