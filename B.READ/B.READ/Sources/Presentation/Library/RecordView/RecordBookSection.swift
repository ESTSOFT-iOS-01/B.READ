//
//  RecordBookSection.swift
//  B.READ
//
//  Created by 심근웅 on 5/23/25.
//

import SwiftUI

// MARK: - (S)RecordBookSection
struct RecordBookSection: View {
  private let book: Book?
  
  init(book: Book? = nil) {
    self.book = book
  }
  
  var body: some View {
    VStack(spacing: 24) {
      Group {
        if let imageData = book?.coverImage,
           let image = UIImage(data: imageData) {
          Image(uiImage: image)
            .resizable()
        } else {
          // TODO: - 사진이 없을때, 들어갈 이미지 or 도형 추가
          Rectangle()
            .fill(.red.opacity(0.2))
        }
      } // : Group
      .frame(width: 176, height: 284)
      .cornerRadius(6)
      
      VStack(alignment: .leading, spacing: 8) {
        Text(book?.name ?? "제목")
          .brStyleFont(.pretendard(.semiBold, size: 24), lineHeight: 1)
          .lineLimit(1)
        
        // FIXME: - 확인해보고 weight, size 수정해야할듯 - light는 괜찮은듯 한데, size 12가 너무 작은듯
        Text(book?.author ?? "작가")
          .brStyleFont(.pretendard(.light, size: 12), lineHeight: 1)
          .lineLimit(1)
          .foregroundStyle(.gray3)
        
      } // : VStack
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    } // : VStack
  }
}
//
//#Preview {
//  RecordDetailView(viewModel: .init(
//    recordID: DummyData.dummyRecords[2].id,
//    isbn: DummyData.dummyRecords[2].isbn
//  ))
//}
