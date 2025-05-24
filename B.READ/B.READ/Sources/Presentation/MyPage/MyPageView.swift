//
//  MyPageView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

struct MyPageView: View {
  
  @EnvironmentObject private var coordinator: Coordinator<MyPageRoute>
  
  var body: some View {
    NavigationStack(path: $coordinator.paths) {
      VStack(alignment: .leading, spacing: 32) {
        
        nicknameButton()
        
        MenuListView(coordinator: coordinator)
        
      }
      .padding(.horizontal, 24)
      .frame(maxHeight: .infinity, alignment: .top)
      .background(.backgroundDefault)
      .toolbar(coordinator.paths.isEmpty ? .visible : .hidden, for: .tabBar)
      .navigationDestination(for: MyPageRoute.self) { route in
        coordinator.buildView(for: route)
      }
    }
  }
  
  // MARK: (F)nicknameButton
  @ViewBuilder
  private func nicknameButton() -> some View {
    Button {
      coordinator.push(.insertNickname)
    } label: {
      HStack(spacing: 14) {
        Text("닉네임")
          .foregroundStyle(.gray9)
          .brStyleFont(.pretendard(.bold, size: 24), lineHeight: 1.45, letterSpacing: 0.02)
        Image(systemName: "chevron.right")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 6)
          .foregroundStyle(.gray5)
      }.frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

// MARK: - (S)MenuListView
private struct MenuListView: View {
  
  let coordinator: Coordinator<MyPageRoute>
  
  // TODO: Entity로 빼고 이미지는 Ext에서 처리할지 고민
  enum WeekDay: Int, CaseIterable {
    case sun = 1
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    
    var streakImage: Image {
      switch self {
      case .sun, .sat:
        Image(.stampS)
      case .mon:
        Image(.stampM)
      case .tue, .thu:
        Image(.stampT)
      case .wed:
        Image(.stampW)
      case .fri:
        Image(.stampF)
      }
    }
  }
  
  private let menuSpacing = 24.0
  private let menuInnerSpacing = 8.0
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      menuTitle(title: "금주의 책빵", subtitle: "문장을 수집하거나 메모를 남기면 불이 들어와요")
      
      HStack {
        ForEach(WeekDay.allCases, id: \.self) {
          streakImage(weekDay: $0)
        }
      }.padding(.top, menuInnerSpacing)
      
      VStack(alignment: .leading, spacing: menuInnerSpacing) {
        menuTitle(title: "관심 분야", chevronHidden: false)
        selectedCategories(categories: [.classics, .artCulture])
      }
      .padding(.top, menuSpacing)
      .onTapGesture {
        coordinator.push(.selectCategory)
      }
      
      
      // TODO: Sprint 2
      //menuTitle(title: "오늘의 빵식이 요약 횟수", subtitle: "매일 자정에 초기화됩니다")
      
      // TODO: Sprint 3
      //menuTitle(title: "SNS 인증")
      
      Button {
        print("초기화")
      } label: {
        Text("초기화")
          .brStyleFont(.pretendard(.light, size: 18), lineHeight: 1.35, letterSpacing: 0.02)
          .foregroundStyle(.red)
          .underline()
      }.padding(.top, menuSpacing)

      Image(.readBreadMyPage)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      
    }.frame(maxWidth: .infinity, alignment: .leading)
  }
  
  // MARK: (F)menuTitle
  @ViewBuilder
  private func menuTitle(
    title: String,
    subtitle: String? = nil,
    chevronHidden: Bool = true
  ) -> some View {
    HStack(spacing: 8) {
      VStack(alignment: .leading, spacing: 0) {
        Text(title)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.35, letterSpacing: 0.02)
        if let subtitle {
          Text(subtitle)
            .brStyleFont(.pretendard(.light, size: 12), lineHeight: 1.2, letterSpacing: -0.02)
        }
      }
      
      Image(systemName: "chevron.right")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 6)
        .foregroundStyle(.gray5)
        .opacity(chevronHidden ? 0 : 1)
    }
  }
  
  // MARK: (F)selectedCategories
  @ViewBuilder
  private func selectedCategories(categories: [CategoryType]) -> some View {
    HStack(spacing: 12) {
      ForEach(categories, id: \.self) {
        Text($0.name)
          .foregroundStyle(.gray7)
          .brStyleFont(.pretendard(.medium, size: 12), lineHeight: 1.0, letterSpacing: -0.025)
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .background(.gray2.opacity(0.2))
          .clipShape(Capsule())
      }
    }
  }
  
  // MARK: (F)streakImage
  @ViewBuilder
  private func streakImage(weekDay: WeekDay) -> some View {
    weekDay.streakImage
      .renderingMode(.template)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 40, height: 40)
      .frame(maxWidth: .infinity)
      .foregroundStyle(weekDay.rawValue % 2 == 0 ? .gray1 : .gray9)
  }
}



#Preview {
  MyPageView()
    .environmentObject(Coordinator<MyPageRoute>())
}
