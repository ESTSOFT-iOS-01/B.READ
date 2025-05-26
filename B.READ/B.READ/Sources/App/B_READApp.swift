//
//  B_READApp.swift
//  B.READ
//
//  Created by 신승재 on 5/7/25.
//

import SwiftUI

@main
struct B_READApp: App {
  
  init() {
    DIContainer.config()
  }
  
  var body: some Scene {
    WindowGroup {
      RootViewSwitcher()
    }
  }
}
