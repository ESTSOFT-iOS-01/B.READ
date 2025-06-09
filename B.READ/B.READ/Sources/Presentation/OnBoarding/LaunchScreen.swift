//
//  LaunchScreen.swift
//  B.READ
//
//  Created by 김도연 on 6/7/25.
//

import SwiftUI

struct LaunchScreen: View {
  @State private var scale: CGFloat = 1.0

  var body: some View {
    VStack(spacing: 30) {
      Image(.splash)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 80, height: 80)
        .scaleEffect(scale)
        .onAppear {
          animatePulse()
        }

      Image(.splashLogo)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 180)
        .padding(.bottom, 100)
    }
  }

  private func animatePulse() {
    let baseScale: CGFloat = 1.0
    let peakScale: CGFloat = 1.15
    let duration: TimeInterval = 0.3
    let pause: TimeInterval = 2.0

    func pulseOnce() {
      withAnimation(.interpolatingSpring(stiffness: 200, damping: 5)) {
        scale = peakScale
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
        withAnimation(.interpolatingSpring(stiffness: 200, damping: 5)) {
          scale = baseScale
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration + pause) {
          pulseOnce()
        }
      }
    }

    pulseOnce()
  }
}

#Preview {
  LaunchScreen()
}
