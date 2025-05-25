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
      breadGuide()
      
      RecentBookSectionView()
        .padding(.top, 24)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // TODO: 컨텐츠 들어오면 maxHeigth 빼기
    .background(.backgroundDefault)
  }
  
  // MARK: (F)breadGuide
  @ViewBuilder
  private func breadGuide() -> some View {
    HStack(spacing: 16.5) {
      Image(.happyBread)
      VStack(alignment: .trailing, spacing: 5) {
        Text("빵식이가 요약할 수 있는 책이 있어요!")
          .foregroundStyle(.gray9)
          .brStyleFont(.pretendard(.semiBold, size: 13), lineHeight: 1.3, letterSpacing: 0.02)
        HStack(spacing: 3) {
          Text("자세히 보기")
            .brStyleFont(.pretendard(.regular, size: 10), lineHeight: 1.3, letterSpacing: 0.02)
          Image(systemName: "chevron.right")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 7, height: 7)
        }.foregroundStyle(.gray5)
      }
      .padding(.vertical, 8)
      .padding(.horizontal, 16)
      .background(.brown4.opacity(0.4))
      .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight, .bottomRight]))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.leading, 24)
  }
}

private struct RecentBookSectionView: View {
  
  @State private var currentIndex = 0
  
  var body: some View {
    VStack(spacing: 16) {
      HStack(alignment: .bottom) {
        Text("최근에 읽은 도서")
          .foregroundStyle(.gray9)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        indicator()

      }.padding(.horizontal, 24)
      
      TabView(selection: $currentIndex) {
        ForEach(0...2, id: \.self) { index in
          LibraryListCell(record: DummyData.dummyRecords.first!)
            .frame(height: 114)
            .background(.green1.opacity(0.6))
            .cornerRadius(16)
            .padding(.horizontal, 24)
            .tag(index)
        }
      }
      .frame(height: 114)
      .tabViewStyle(.page(indexDisplayMode: .never))
    }
  }
  
  // MARK: (F)indicator
  @ViewBuilder
  private func indicator() -> some View {
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

#Preview {
  HomeView()
}
