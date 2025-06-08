//
//  MemoCoordinator.swift
//  B.READ
//
//  Created by 신승재 on 6/5/25.
//

import SwiftUI

enum MemoRoute: Hashable {
  case memo(id: String? = nil, record: RecordDetailVO)
}

final class MemoCoordinator: Coordinator<MemoRoute, Never> {
  
  @ViewBuilder
  func buildView(for route: MemoRoute) -> some View {
    switch route {
    case .memo(let id, let record):
      MemoView(viewModel: MemoViewModel(id: id, record: record), totalPage: record.totalPage)
    }
  }
}
