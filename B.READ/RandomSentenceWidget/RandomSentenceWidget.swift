//
//  RandomSentenceWidget.swift
//  RandomSentenceWidget
//
//  Created by 도민준 on 6/9/25.
//

import WidgetKit
import SwiftUI

// MARK: - Entry
struct QuoteEntry: TimelineEntry {
  let date: Date          // 타임라인 기준 시각
  let quote: String       // 인용 문장
  let bookTitle: String   // 책 제목(없으면 "")
}

// MARK: - Provider
struct QuoteProvider: TimelineProvider {
  
  func placeholder(in context: Context) -> QuoteEntry {
    QuoteEntry(date: .now,
               quote: "책 속의 한 문장을 표시합니다.",
               bookTitle: "Placeholder Book")
  }
  
  func getSnapshot(in context: Context,
                   completion: @escaping (QuoteEntry) -> Void) {
    completion(randomEntry())
  }
  
  func getTimeline(in context: Context,
                   completion: @escaping (Timeline<QuoteEntry>) -> Void) {
    
    let entry      = randomEntry()
    let nextUpdate = entry.date.addingTimeInterval(3)     // 8 초 테스트
    
    completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
  }
  
  // SharedQuotesStore → 랜덤 추출
  private func randomEntry() -> QuoteEntry {
    let picked = SharedQuotesStore.load().randomElement()
    return QuoteEntry(
      date: .now,
      quote: picked?.content ?? "저장된 문장이 없습니다.",
      bookTitle: picked?.bookTitle ?? ""
    )
  }
}



struct RandomSentenceWidgetEntryView : View {
  var entry: QuoteEntry
  
  var body: some View {
    HStack(spacing: 12) {
      Image("HappyBread")
        .resizable()
        .scaledToFit()
        .frame(width: 56, height: 56)
      
      VStack {
        Text(entry.quote)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.2)
          .lineLimit(4)
          .multilineTextAlignment(.trailing)
          .minimumScaleFactor(0.6)
          .frame(maxWidth: .infinity, alignment: .trailing)
        
        if !entry.bookTitle.isEmpty {
          Text("– \(entry.bookTitle) –")
            .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
      }
    }
    .padding()
  }
}

struct RandomSentenceWidget: Widget {
  let kind: String = "RandomSentenceWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: QuoteProvider()) { entry in
      if #available(iOS 17.0, *) {
        RandomSentenceWidgetEntryView(entry: entry)
          .containerBackground(.fill.tertiary, for: .widget)
      } else {
        RandomSentenceWidgetEntryView(entry: entry)
          .padding()
          .background(.backgroundDefault)
      }
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}


#Preview(as: .systemMedium) {
  RandomSentenceWidget()
} timeline: {
  QuoteEntry(date: .now, quote: "위젯 미리보기입니다.", bookTitle: "도서1")
  QuoteEntry(date: .now, quote: "또 다른 문장 미리보기.", bookTitle: "도서2")
}
