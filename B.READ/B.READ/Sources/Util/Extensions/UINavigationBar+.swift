//
//  UINavigationBar+.swift
//  B.READ
//
//  Created by 신승재 on 5/24/25.
//

import UIKit

extension UINavigationBar {
  static func configureGlobalAppearance() {
    let defaultAppearance = UINavigationBarAppearance()
    let backAppearance = UIBarButtonItemAppearance()
    backAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
    defaultAppearance.backButtonAppearance = backAppearance
    defaultAppearance.titleTextAttributes = [
      .font: UIFont.pretendard(.light, size: 16),
      .foregroundColor: UIColor.black
    ]
    
    let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
    let chevronImage = UIImage(systemName: "chevron.backward", withConfiguration: config)?
      .withTintColor(.green6, renderingMode: .alwaysOriginal)
      .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0))
    defaultAppearance.setBackIndicatorImage(chevronImage, transitionMaskImage: chevronImage)
    
    let navigationBar = UINavigationBar.appearance()
    navigationBar.standardAppearance = defaultAppearance
    navigationBar.compactAppearance = defaultAppearance
  }
}
