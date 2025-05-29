//
//  HomeView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

struct HomeView: View {
  var body: some View {
    ScrollView {
      BreadGuideView()
      
      RecentBookSectionView()
        .padding(.top, 24)
    }
    .frame(maxWidth: .infinity, alignment: .top)
    .background(.backgroundDefault)
  }
}

// MARK: - (S)BreadGuideView
private struct BreadGuideView: View {
  var body: some View {
    HStack(alignment: .top, spacing: 16.5) {
      
      Image(.happyBread)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 100, height: 109)
      
      VStack(alignment: .trailing, spacing: 5) {
        Text("빵식이가 요약할 수 있는 책이 있어요!")
          .foregroundStyle(.gray9)
          .brStyleFont(.pretendard(.semiBold, size: 13), lineHeight: 1.3, letterSpacing: 0.02)
        
        talkBubble()
      }
      .padding(.vertical, 8)
      .padding(.horizontal, 16)
      .background(.brown4.opacity(0.4))
      .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight, .bottomRight]))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.leading, 24)
  }
  
  // MARK: (F)talkBubble
  @ViewBuilder
  private func talkBubble() -> some View {
    HStack(spacing: 3) {
      Text("자세히 보기")
        .brStyleFont(.pretendard(.regular, size: 10), lineHeight: 1.3, letterSpacing: 0.02)
      Image(systemName: "chevron.right")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 7, height: 7)
    }.foregroundStyle(.gray5)
  }
}

// MARK: - (S)RecentBookSectionView
private struct RecentBookSectionView: View {
  
  @State private var currentIndex = 0
  
  var body: some View {
    VStack(spacing: 16) {
      HStack(alignment: .bottom) {
        Text("최근에 읽은 도서")
          .foregroundStyle(.gray9)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        pageIndicator()

      }.padding(.horizontal, 24)
      
      InfiniteBannerView(currentIndex: $currentIndex)
    }
  }
  
  // MARK: (F)pageIndicator
  @ViewBuilder
  private func pageIndicator() -> some View {
    ForEach(0...2, id: \.self) { index in
      HStack(spacing: 6) {
        Circle()
          .fill(currentIndex == index ? .green5 : .gray1)
          .frame(width: 6, height: 6)
          .animation(.easeInOut(duration: 0.2), value: currentIndex)
      }
    }
  }
}


// MARK: - (S)InfiniteBannerView
private struct InfiniteBannerView: View {
  @EnvironmentObject var coordinator: Coordinator<MainRoute>
  // TODO: 근웅님한테 Cell이 Entity가 넘어가지 않게 해달라고 요청
  @State var items = [
    LibraryRecordVO(id: "", isbn: "", name: "", state: .completed, heartCount: 1, starCount: 1, percent: 20, memoCount: 1, quoteCount: 1, period: (.now, .now), isFavorite: true, createdAt: .now),
    LibraryRecordVO(id: "", isbn: "", name: "", state: .completed, heartCount: 1, starCount: 1, percent: 20, memoCount: 1, quoteCount: 1, period: (.now, .now), isFavorite: true, createdAt: .now),
    LibraryRecordVO(id: "", isbn: "", name: "", state: .completed, heartCount: 1, starCount: 1, percent: 20, memoCount: 1, quoteCount: 1, period: (.now, .now), isFavorite: true, createdAt: .now)
  ]
  @Binding var currentIndex: Int
  
  var body: some View {
    TabView(selection: $currentIndex) {
      bannerCell(recordVO: $items.last!)
        .tag(-1)

      ForEach($items.indices, id: \.self) { index in
        bannerCell(recordVO: $items[index])
          .tag(index)
          .onTapGesture {
            coordinator.push(.libraryDetail(id: items[index].id, isbn: items[index].isbn))
          }
      }
      .onDisappear {
        if currentIndex == -1 {
          currentIndex = items.count - 1
        } else if currentIndex == items.count {
          currentIndex = 0
        }
      }

      bannerCell(recordVO: $items.first!)
        .tag(items.count)
    }
    .frame(height: 114)
    .tabViewStyle(.page(indexDisplayMode: .never))
    .onAppear {
      currentIndex = 0
    }
  }
  
  // MARK: (F)bannerCell
  @ViewBuilder
  private func bannerCell(recordVO: Binding<LibraryRecordVO>) -> some View {
    LibraryListCell(record: recordVO)
      .background(.green1.opacity(0.6))
      .cornerRadius(16)
      .padding(.horizontal, 24)
  }
}

#Preview {
  HomeView()
}
