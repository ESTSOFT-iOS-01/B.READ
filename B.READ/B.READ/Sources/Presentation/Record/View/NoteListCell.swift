//
//  NoteListCell.swift
//  B.READ
//
//  Created by 심근웅 on 6/7/25.
//

import SwiftUI

struct NoteListCell: View {
  @Binding var note: NoteVO
  
  var body: some View {
    HStack(alignment: .top, spacing: 24) {
      coverImage()
        .frame(width: 57, height: 88)
        .cornerRadius(6)
      
      VStack(alignment: .leading, spacing: 8) {
        Text(note.bookTitle)
          .foregroundStyle(.gray9)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.0)
          .lineLimit(1)
          .truncationMode(.tail)
        
        Text(note.author)
          .foregroundStyle(.brown8)
          .brStyleFont(.pretendard(.medium, size: 14), lineHeight: 1.15)
          .lineLimit(1)
          .truncationMode(.tail)
        Text(note.createdAt.string(format: .dotSeparated))
          .foregroundStyle(.brown5)
          .brStyleFont(.pretendard(.regular, size: 12), lineHeight: 1.15, letterSpacing: -0.025)
          .lineLimit(1)
          .truncationMode(.tail)
      } // : VStack
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 4)
    } // : HStack
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 8)
    .padding(.vertical, 16)
    .background(.backgroundDefault)
  }
  
  // MARK: - (F)coverImage
  @ViewBuilder
  private func coverImage() -> some View {
    if let coverImage = note.coverImage {
      coverImage
        .resizable()
        .aspectRatio(contentMode: .fill)
    } else {
      Image(.exampleBook)
        .resizable()
        .aspectRatio(contentMode: .fill)
    }
  }
}

#Preview {
  @Previewable @State var note = NoteVO(
    id: "1",
    bookTitle: "싯타르타",
    author: "헤르만헤세",
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 19))!,
    coverImage: Image(.exampleBook),
    content: "테스트테스트테스트테스트테스트테스트",
    recordId: "3"
  )
  PreviewableContainer {
    NoteListCell(note: $note)
  }
}
