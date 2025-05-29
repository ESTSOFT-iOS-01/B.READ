//
//  PrevieweableContainer.swift
//  B.READ
//
//  Created by 신승재 on 5/29/25.
//

import SwiftUI

struct PreviewableContainer<Content: View>: View {
  @State private var isReady: Bool = false
  private let content: () -> Content

  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }

  var body: some View {
    Group {
      if isReady {
        content()
      } else {
        Color.white
          .ignoresSafeArea()
          .task {
            await DIContainer.config()
            await MainActor.run {
              self.isReady = true
            }
          }
      }
    }
  }
}
