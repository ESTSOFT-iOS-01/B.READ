//
//  RecordBookSection.swift
//  B.READ
//
//  Created by 심근웅 on 5/23/25.
//

import SwiftUI

// MARK: - (S)RecordBookSection
struct RecordBookSection: View {
  @Binding var record: RecordDetailVO?
  
  var body: some View {
    VStack(spacing: 24) {
      Group {
        if let coverImage = record?.coverImage {
          coverImage
            .resizable()
            .aspectRatio(contentMode: .fill)
        } else {
          // TODO: - [시르] 사진이 없을때, 들어갈 이미지 or 도형 추가
          Image(.exampleBook)
            .resizable()
            .aspectRatio(contentMode: .fill)
        }
      } // : Group
      .frame(width: 176, height: 284)
      .cornerRadius(6)
      
      VStack(alignment: .leading, spacing: 8) {
        Text(record?.title ?? "제목")
          .brStyleFont(.pretendard(.semiBold, size: 24), lineHeight: 1)
          .lineLimit(1)
        Text(record?.author ?? "작가")
          .brStyleFont(.pretendard(.light, size: 14), lineHeight: 1)
          .lineLimit(1)
          .foregroundStyle(.gray3)
        
      } // : VStack
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    } // : VStack
  }
}

#Preview {
  @Previewable @State var recordDetail: RecordDetailVO? = RecordDetailVO(
    record: DummyData.dummyRecords[1],
    book: DummyData.dummyBooks[1]
  )
  PreviewableContainer {
    RecordBookSection(record: $recordDetail)
  }
}
