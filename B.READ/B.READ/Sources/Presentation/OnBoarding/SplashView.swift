//
//  SplashView.swift
//  B.READ
//
//  Created by 김도연 on 6/7/25.
//

import SwiftUI

struct SplashView: View {
  @State private var bounce = false
  
  var body: some View {
    VStack(spacing: 0) {
//      Image(.splash)
//        .resizable()
//        .aspectRatio(contentMode: .fit)
//        .frame(width: 100, height: 100)
//        .offset(y: bounce ? -20 : 10)
//        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: bounce)
//        .onAppear {
//          bounce.toggle()
//        }
      
      Image(.splashLogo)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 240)
      
    }
  }
}

#Preview {
  SplashView()
}
