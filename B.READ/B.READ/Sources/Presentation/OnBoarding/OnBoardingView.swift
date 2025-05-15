//
//  OnBoardingView.swift
//  B.READ
//
//  Created by 신승재 on 5/14/25.
//

import SwiftUI


struct OnBoardingView: View {
  
  @State private var currentStep: OnboardingStep = .guide
  
  var body: some View {
    VStack(spacing: 0) {
      
      pageIndicator()
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 38)
        .padding(.trailing, 40)
      
      PageView(currentStep: $currentStep)
      
      BottomButton(
        buttonTitle: currentStep == .assistant ? "로그인 하러 가기" : "다음으로",
        textColor: currentStep == .assistant ? .backgroundDefault : .brown7,
        buttonColor: currentStep == .assistant ? .brown3 : .brown1
      ) {
        if currentStep.rawValue < OnboardingStep.allCases.count - 1 {
          currentStep = OnboardingStep.allCases[currentStep.rawValue + 1]
        }
      }
      .padding(.horizontal, 30)
      .animation(.easeInOut(duration: 0.2), value: currentStep)
      
    }.background(.backgroundDefault)
  }
  
  // MARK: (F)pageIndicator
  @ViewBuilder
  private func pageIndicator() -> some View {
    HStack(spacing: 6) {
      ForEach(OnboardingStep.allCases, id: \.self) {
        Circle()
          .fill(currentStep == $0 ? .orange3 : .gray1)
          .frame(width: 6, height: 6)
      }
    }.animation(.easeInOut(duration: 0.5), value: currentStep)
  }
}


// MARK: - (S)PageView
private struct PageView: View {
  
  @Binding var currentStep: OnboardingStep
  
  var body: some View {
    TabView(selection: $currentStep) {
      ForEach(OnboardingStep.allCases, id: \.self) {
        PageContentView(step: $0).tag($0)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .animation(.spring(duration: 0.5), value: currentStep)
  }
}

// MARK: - (S)PageContentView
private struct PageContentView: View {
  
  let step: OnboardingStep
  
  var body: some View {
    GeometryReader { proxy in
      VStack(alignment: .leading, spacing: 0) {
        Text(step.title)
          .brStyleFont(.peaceSans(size: 32), lineHeight: 1.0)
          .padding(.leading, 56)
          .padding(.top, proxy.size.height*0.0966)
        
        Text(step.content)
          .brStyleFont(.pretendard(.light, size: 18), lineHeight: 1.6)
          .padding(.top, proxy.size.height*0.0604)
          .padding(.leading, 56)
        
        step.image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
          .padding(.horizontal, 33)
          .padding(.bottom, proxy.size.height*0.0966)
      }
    }
  }
}

#Preview {
  OnBoardingView()
}
