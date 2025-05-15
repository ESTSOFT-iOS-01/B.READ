//
//  SearchView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

struct SearchView: View {
  @State var searchText : String = ""
  var barcordAction: () -> Void = {
    print("바코드 버튼 눌림 -> 바코드 인식 화면으로 전환")
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 16) {
        SearchBar(text: $searchText)
        SearchButton(icon: SearchConstants.Icon.barcord, action: barcordAction)
      }
    }
  }
}

#Preview {
  SearchView()
}
