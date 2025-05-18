//
//  LibraryListCell.swift
//  B.READ
//
//  Created by 심근웅 on 5/17/25.
//

import SwiftUI

// MARK: - (S)LibraryListCell
struct LibraryListCell: View {
  
  let record: Record
  @State var image: Image?
  
  var body: some View {
    HStack(spacing: 0) {
      // TODO: - (DB연결 후)Book 표지가 들어갈 자리
      if image != nil {
        image?
          .resizable()
          .frame(width: 57, height: 88)
          .cornerRadius(6)
      } else {
        // TODO: - 사진이 없을때, 들어갈 이미지 or 도형 추가
        Rectangle()
          .fill(.red.opacity(0.2))
          .frame(width: 57, height: 88)
          .cornerRadius(6)
      }
        
      VStack(alignment: .leading, spacing: 6) {
        // 도서 제목
        Text(DummyData.dummyBooks[record.isbn]!.name)
          .lineLimit(2)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1)
        
        // 독서 현황
        recordStatsView()
          .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1)
        
        // 독서 기간
        recordPeriod()
          .brStyleFont(.pretendard(.regular, size: 12), lineHeight: 1, letterSpacing: -0.025)
          .foregroundStyle(.brown5)
        
      } // : VStack
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .padding(.top, 16)
      .padding(.leading, 24)
      .padding(.trailing, record.isFavorite ? 2 : 40)
      
      if record.isFavorite {
        Image(systemName: "bookmark.fill")
          .resizable()
          .foregroundStyle(.green4)
          .frame(width: 14, height: 28)
          .frame(maxHeight: .infinity, alignment: .top)
      }
      
    } // : HStack
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, 24)
    .onAppear { // 여기부분은 임시로 사용하는 내용입니다!
      // TODO: - (DB연결 후)이미지는 임시로 그냥 사용, 추후 정상적으로 저장된 표지 이미지 불러오는 코드 작성필요
      DispatchQueue.global().async {
        let dummyURL = "https://image.aladin.co.kr/product/17048/25/cover500/8932473900_1.jpg"
        let url = URL(string: dummyURL)!
        if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
          DispatchQueue.main.async {
            self.image = Image(uiImage: image)
          }
        }
      }
    }
  }
 
  
  // MARK: - (F)recordStatsView
  @ViewBuilder
  private func recordStatsView() -> some View {
    HStack(spacing: 12) {
      switch record.state {
      case .toRead: // 기대지수
        propertyView("heart.fill", "\(record.heartCount)")
        
      case .reading: // 독서진행률
        let totalPage = Double(DummyData.dummyBooks[record.isbn]!.totalPages)
        let currentPage = Double(record.currentPage)
        let percent = Int(currentPage / totalPage * 100)
        propertyView("timer", "\(percent)%")
        
      case .completed: // 평점
        propertyView("star.fill", "\(record.starCount)")
      }
      
      propertyView("note.text", "\(record.starCount)개") // 메모
      
      propertyView("ellipsis.bubble", "\(record.starCount)개") // 문장
    } // : HStack
  }

  
  // MARK: - (F)propertyView
  // TODO: - (1)공통컴포넌트로 분리
  @ViewBuilder
  public func propertyView(_ iconName: String, _ content: String) -> some View {
    HStack(spacing: 4) {
      Image(systemName: iconName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 16, height: 16, alignment: .center)
      
      Text(content)
        .brStyleFont(.pretendard(.medium, size: 14), lineHeight: 1.0)
        .lineLimit(1)
        .truncationMode(.tail)
    }
    .foregroundStyle(.orange9)
  }
  
  // MARK: - (F)recordPeriod
  @ViewBuilder
  private func recordPeriod() -> some View {
    if record.state == .reading {
      Text("\(record.period.0!.string(format: .dotSeparated)) ~")
      
    } else if record.state == .completed {
      let startDay: String = record.period.0!.string(format: .dotSeparated)
      let endDay: String = record.period.1!.string(format: .dotSeparated)
      Text("\(startDay) ~ \(endDay)")
    }
  }
}
