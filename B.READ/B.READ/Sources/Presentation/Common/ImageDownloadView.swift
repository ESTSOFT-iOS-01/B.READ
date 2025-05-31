//
//  ImageDownloadView.swift
//  B.READ
//
//  Created by 김도연 on 5/31/25.
//

import SwiftUI

struct ImageDownloadView: View {
  @State private var imageData: Data? = nil
  @State private var errorMessage: String? = nil
  
  private let imageURL = "https://image.aladin.co.kr/product/9871/8/cover500/k042535550_2.jpg"
  
  var body: some View {
    VStack {
      if let data = imageData, let uiImage = UIImage(data: data) {
        Image(uiImage: uiImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: 300, maxHeight: 300)
          .cornerRadius(12)
          .shadow(radius: 8)
      } else if let error = errorMessage {
        Text("에러: \(error)")
          .foregroundColor(.red)
      } else {
        ProgressView("이미지 로딩 중...")
      }
    }
    .task {
      do {
        let data = try await ImageConverter.convertImageURLToData(imageURL)
//        print(data.count)
        imageData = data
      } catch {
        errorMessage = error.localizedDescription
      }
    }
    .padding()
  }
}
