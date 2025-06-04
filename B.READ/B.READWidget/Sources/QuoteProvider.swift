//
//  QuoteProvider.swift
//  B.READ
//
//  Created by 도민준 on 6/4/25.
//


import WidgetKit
import SwiftUI

struct QuoteProvider: TimelineProvider {
  
  private let sharedDefaults = UserDefaults(suiteName: "group.BREAD")
  
  func placeholder(in context: Context) -> QuoteEntry {
    QuoteEntry(date: Date(), quote: "문장을 불러오는 중...")
  }
  
  func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
    let entry = QuoteEntry(date: Date(), quote: randomQuote())
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
    let currentDate = Date()
    let entry = QuoteEntry(date: currentDate, quote: randomQuote())
    
    let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
    
    let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
    completion(timeline)
  }
  
  private func randomQuote() -> String {
    guard let quotes = sharedDefaults?.stringArray(forKey: "quotes"), !quotes.isEmpty else {
      return "문장이 없어요!"
    }
    return quotes.randomElement()!
  }
}
