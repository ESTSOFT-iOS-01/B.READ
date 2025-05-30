//
//  B_READApp.swift
//  B.READ
//
//  Created by 신승재 on 5/7/25.
//

import SwiftUI

@main
struct B_READApp: App {
  
//  init() {
//    // 커스텀 ValueTransformer 등록
//    ValueTransformer.setValueTransformer(
//      StringArrayTransformer(),
//      forName: NSValueTransformerName("StringArrayTransformer")
//    )
//  }
  
  var body: some Scene {
    WindowGroup {
      RootViewSwitcher()
    }
  }
}
