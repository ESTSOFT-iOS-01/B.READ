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
      note.coverImage
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 57, height: 88)
        .cornerRadius(6)
      
      VStack(alignment: .leading, spacing: 8) {
        Text(note.record.title)
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
}


#Preview {
  @Previewable @State var note = NoteVO(
    note: DummyData.summary1,
    record: DummyData.dummyRecords[0],
    book: DummyData.dummyBooks[0]
  )
  PreviewableContainer {
    NoteListCell(note: $note)
  }
}
