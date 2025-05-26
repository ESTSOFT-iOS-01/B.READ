//
//  UINavigationBar+.swift
//  B.READ
//
//  Created by 신승재 on 5/24/25.
//

import UIKit

extension UINavigationBar {
  static func configureGlobalAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .clear
    appearance.shadowColor = .clear

    let backAppearance = UIBarButtonItemAppearance()
    backAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
    appearance.backButtonAppearance = backAppearance

    let chevronImage = UIImage(systemName: "chevron.left")?
      .withTintColor(.green6, renderingMode: .alwaysOriginal)
    appearance.setBackIndicatorImage(chevronImage, transitionMaskImage: chevronImage)

    let navigationBar = UINavigationBar.appearance()
    navigationBar.standardAppearance = appearance
    navigationBar.scrollEdgeAppearance = appearance
    navigationBar.compactAppearance = appearance
  }
}
