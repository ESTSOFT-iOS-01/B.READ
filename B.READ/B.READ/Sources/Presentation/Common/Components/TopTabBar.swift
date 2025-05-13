//
//  TopTabBar.swift
//  B.READ
//
//  Created by 신승재 on 5/13/25.
//

import SwiftUI

struct TabItem {
  let title: String
  let selectedImage: Image?
  let unselectedImage: Image?
  
  init(title: String, selectedImage: Image? = nil, unselectedImage: Image? = nil) {
    self.title = title
    self.selectedImage = selectedImage
    self.unselectedImage = unselectedImage
  }
}

// MARK: - (S)TopTabBar
struct TopTabBar: View {
  
  let tabs: [TabItem]
  @Binding var selectedIndex: Int
  
  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: 8) {
        HeaderView(tabs: tabs, selectedIndex: $selectedIndex)
        barIndicator(totalWidth: proxy.size.width)
      }
    }
  }
  
  // MARK: (F)barIndicator
  @ViewBuilder
  private func barIndicator(totalWidth: CGFloat) -> some View {
    
    let width = totalWidth / CGFloat(tabs.count)
    let offset = width * CGFloat(selectedIndex)
    
    Rectangle()
      .fill(.orange7)
      .frame(width: width, height: 2)
      .frame(maxWidth: .infinity, alignment: .leading)
      .offset(x: offset)
      .animation(.easeInOut(duration: 0.25), value: offset)
  }
}

// MARK: - (S)HeaderView
private struct HeaderView: View {
  
  let tabs: [TabItem]
  @Binding var selectedIndex: Int
  
  var body: some View {
    HStack(spacing: 0) {
      ForEach(tabs.indices, id: \.self) { index in
        let isSelected = index == selectedIndex
        let hasImage = tabs[index].selectedImage != nil
        
        if hasImage {
          imageLabel(index: index, isSelected: isSelected)
            .padding(.trailing, 4)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        
        Text(tabs[index].title)
          .foregroundStyle(isSelected ? .brown7 : .gray2)
          .frame(maxWidth: .infinity, alignment: hasImage ? .leading : .center)
          .brStyleFont(
            .pretendard(isSelected ? .semiBold : .medium, size: 16),
            lineHeight: 1.2
          )
          .onTapGesture {
            self.selectedIndex = index
          }
      }
    }
  }
  
  // MARK: (F)imageLabel
  @ViewBuilder
  private func imageLabel(index: Int, isSelected: Bool) -> some View {
    if isSelected {
      tabs[index].selectedImage
    } else {
      tabs[index].unselectedImage
    }
  }
}

#Preview {
  @Previewable @State var selectedIndex = 0
  let tabs = [
    TabItem(title: "공지사항"),
    TabItem(title: "커뮤니티")
  ]
  VStack {
    TopTabBar(tabs: tabs, selectedIndex: $selectedIndex)
  }.padding(.horizontal, 24)
}

#Preview {
  @Previewable @State var selectedIndex = 0
  let tabs = [
    TabItem(title: "메모", selectedImage: Image(.donut), unselectedImage: Image(.donut)),
    TabItem(title: "문장", selectedImage: Image(.donut), unselectedImage: Image(.donut))
  ]
  TopTabBar(tabs: tabs, selectedIndex: $selectedIndex)
}
