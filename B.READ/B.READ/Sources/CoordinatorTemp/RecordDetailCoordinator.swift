//
//  RecordDetailCoordinator.swift
//  B.READ
//
//  Created by 신승재 on 6/5/25.
//

import SwiftUI

enum RecordDetailRoute: Hashable {
  case RecordDetail(id: String)
}

final class RecordDetailCoordinator: Coordinator<RecordDetailRoute, Never> {
  
  @ViewBuilder
  func buildView(for route: RecordDetailRoute) -> some View {
    switch route {
    case .RecordDetail(let id):
      RecordDetailView(viewModel: .init(recordID: id))
    }
  }
}
