//
//  BookDetailView.swift
//  B.READ
//
//  Created by 김도연 on 5/22/25.
//

import SwiftUI

struct BookDetailView: View {
  @ObservedObject var viewModel: BookViewModel
  @EnvironmentObject var coordinator: Coordinator<MainRoute>
  
  var body: some View {
    VStack {
      Text(viewModel.text)
        .padding()
      
      Text(viewModel.isbn)
        .padding()
      
      Button {
        coordinator.pop()
      } label: {
        Text("pop page")
          .padding()
          .border(.brown7)
      }

    }
  }
}

//#Preview {
//  BookDetailView()
//}
