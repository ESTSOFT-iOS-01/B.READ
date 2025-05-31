//
//  HomeView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

struct HomeView: View {
  
  @StateObject private var viewModel = HomeViewModel()
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      BreadGuideView()
        .padding(.top, 24)
      
      RecentBookSectionView(viewModel: viewModel)
        .padding(.top, 24)
      
      if viewModel.bestSellerList.count > 1 {
        RecommandSectionView(bookList: viewModel.bestSellerList[0])
          .padding(.top, 24)

        RecommandSectionView(bookList: viewModel.bestSellerList[1])
      }
    }
    .frame(maxWidth: .infinity, alignment: .top)
    .background(.backgroundDefault)
    .onAppear {
      viewModel.send(.onAppear)
    }
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
      Image(systemName: SFSymbol.chevronRight.name)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 7, height: 7)
    }.foregroundStyle(.gray5)
  }
}

// MARK: - (S)RecentBookSectionView
private struct RecentBookSectionView: View {
  
  @ObservedObject var viewModel: HomeViewModel
  @State private var currentIndex = 0
  private let emptyBookPlaceHolder = """
    아직 읽기 시작한 책이 없네요!
    하루 한 쪽이라도 읽어보세요
    
    """
  
  var body: some View {
    VStack(spacing: 16) {
      HStack(alignment: .bottom) {
        Text("최근에 읽은 도서")
          .foregroundStyle(.gray9)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        if !viewModel.recentRecords.isEmpty { pageIndicator() }

      }.padding(.horizontal, 24)
      
      if !viewModel.recentRecords.isEmpty {
        InfiniteBannerView(viewModel: viewModel, currentIndex: $currentIndex)
      } else {
        Text(emptyBookPlaceHolder)
          .multilineTextAlignment(.center)
          .foregroundStyle(.black)
          .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.35, letterSpacing: 0.025)
          .padding(.top, 32)
      }
    }
  }
  
  // MARK: (F)pageIndicator
  @ViewBuilder
  private func pageIndicator() -> some View {
    ForEach(0...viewModel.recentRecords.count - 1, id: \.self) { index in
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
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  @ObservedObject var viewModel: HomeViewModel
  @Binding var currentIndex: Int
  private var totalRecordsCount: Int {
    viewModel.recentRecords.count
  }
  
  var body: some View {
    TabView(selection: $currentIndex) {
      if totalRecordsCount > 1 {
        bannerCell(recordVO: $viewModel.recentRecords[totalRecordsCount - 1])
          .tag(-1)
      }

      ForEach(viewModel.recentRecords.indices, id: \.self) { index in
        bannerCell(recordVO: $viewModel.recentRecords[index])
          .tag(index)
          .onTapGesture {
            coordinator.push(
              .libraryDetail(
                id: viewModel.recentRecords[index].id,
                isbn: viewModel.recentRecords[index].isbn
              )
            )
          }
      }
      .onDisappear {
        if currentIndex == -1 {
          currentIndex = totalRecordsCount - 1
        } else if currentIndex == totalRecordsCount {
          currentIndex = 0
        }
      }

      if totalRecordsCount > 1 {
        bannerCell(recordVO: $viewModel.recentRecords[0])
          .tag(totalRecordsCount)
      }
    }
    .frame(height: 114)
    .tabViewStyle(.page(indexDisplayMode: .never))
    .onAppear {
      currentIndex = 0
    }
  }
  
  // MARK: (F)bannerCell
  @ViewBuilder
  private func bannerCell(recordVO: Binding<RecordCellVO>) -> some View {
    LibraryListCell(record: recordVO)
      .background(.green1.opacity(0.6))
      .cornerRadius(16)
      .padding(.horizontal, 24)
  }
}

// MARK: - (S)RecommandSectionView
private struct RecommandSectionView: View {
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  let bookList: BestSellerListVO
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      RecommandHeaderView(categoryName: bookList.categoryName)
        .padding(.leading, 24)
      
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 0) {
          ForEach(bookList.bestSellers, id: \.id) { item in
            RecommandCell(bestSellerVO: item, onTap: {
              coordinator.push(.searchBook(isbn: item.isbn))
            })
          }
        }
      }
    }
    .padding(.bottom, 24)
  }
}

#Preview {
  PreviewableContainer {
    HomeView()
  }
}
