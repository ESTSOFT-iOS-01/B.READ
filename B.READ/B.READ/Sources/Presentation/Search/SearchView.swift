//
//  SearchView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

struct SearchView: View {
  @State var searchText : String = ""
  @State var searchText1 : String = "zzzz"
  
  var body: some View {
    VStack(alignment: .leading) {
      SearchBar(text: $searchText)
      SearchBar(text: $searchText, style: .compact)
      
      SearchBar(text: $searchText1)
      SearchBar(text: $searchText1, style: .compact)
    }
  }
}

#Preview {
  SearchView()
}
