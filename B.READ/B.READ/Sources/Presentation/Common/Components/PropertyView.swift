//
//  PropertyView.swift
//  B.READ
//
//  Created by 김도연 on 5/18/25.
//

import SwiftUI

// MARK: - (S)PropertyView
public struct PropertyView: View {
  let iconName: String
  let content: String
  let unit: UnitType

  public init(_ iconName: String, _ content: String, _ unit: UnitType = .default) {
    self.iconName = iconName
    self.content = content
    self.unit = unit
  }

  public var body: some View {
    HStack(spacing: 4) {
      Image(systemName: iconName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 12, height: 12, alignment: .center)

      Text(content + unit.expression)
        .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.15, letterSpacing: -0.025)
        .lineLimit(1)
        .truncationMode(.tail)
    }
    .foregroundStyle(.orange9)
  }
}
