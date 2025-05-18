//
//  CategorySelectionView.swift
//  B.READ
//
//  Created by 신승재 on 5/15/25.
//

import SwiftUI

struct CategorySelectionView: View {
  
  @State private var selectedCategories: Set<Category> = []
  private var isButtonEnabled: Bool {
    selectedCategories.count == 2
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      InputGuideHeader(type: .category)
        .padding(.top, 24)
      
      CategoryListView(selectedCategories: $selectedCategories)
        .padding(.top, 24)
      
      BottomButton(
        buttonTitle: "저장하기",
        textColor: isButtonEnabled ?  .backgroundDefault : .gray3,
        buttonColor: isButtonEnabled ? .brown3 : .gray0
      ) {
        print("next")
      }
      .disabled(!isButtonEnabled)
      .animation(.easeInOut(duration: 0.25), value: isButtonEnabled)
      .padding(.horizontal, 6)
      .padding(.top, 12)
      
    }
    .padding(.horizontal, 24)
  }
}

// MARK: - (S)CategoryListView
private struct CategoryListView: View {
  
  @Binding var selectedCategories: Set<Category>
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        ForEach(Category.allCases, id: \.self) {
          SelectionRow(selectedCategories: $selectedCategories, category: $0)
        }
      }
    }.scrollIndicators(.never)
  }
}


// MARK: - (S)SelectionRow
private struct SelectionRow: View {
  
  @Binding var selectedCategories: Set<Category>
  let category: Category
  private var isSelected: Bool {
    selectedCategories.contains(category)
  }
  
  var body: some View {
    Button {
      switch isSelected {
      case false:
        if selectedCategories.count < 2 { selectedCategories.insert(category) }
      case true:
        if selectedCategories.contains(category) { selectedCategories.remove(category) }
      }
    } label: {
      HStack(spacing: 16) {
        Image(systemName: "checkmark")
          .resizable()
          .frame(width: 14, height: 11)
          .foregroundStyle(isSelected ? .brown8 : .gray1)
          .bold(isSelected)
        Text(category.displayName)
          .foregroundStyle(.black)
          .brStyleFont(.pretendard(.medium, size: 18), lineHeight: 1.35, letterSpacing: 0.02)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}

#Preview {
  CategorySelectionView()
}
