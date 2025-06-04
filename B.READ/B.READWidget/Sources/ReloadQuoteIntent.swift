//
//  ReloadQuoteIntent.swift
//  B.READ
//
//  Created by 도민준 on 6/4/25.
//

import AppIntents
import WidgetKit

struct ReloadQuoteIntent: AppIntent {
    static var title: LocalizedStringResource = "Reload Quote"

    func perform() async throws -> some IntentResult {
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
