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
    
    let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
    let chevronImage = UIImage(systemName: SFSymbol.chevronLeft.name, withConfiguration: config)?
      .withTintColor(.green6, renderingMode: .alwaysOriginal)
      .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0))
    defaultAppearance.setBackIndicatorImage(chevronImage, transitionMaskImage: chevronImage)
    
    let navigationBar = UINavigationBar.appearance()
    navigationBar.standardAppearance = defaultAppearance
    navigationBar.compactAppearance = defaultAppearance
  }
}

extension UINavigationBar {
  static func showOverlay(color: UIColor = UIColor.black.withAlphaComponent(0.2), duration: TimeInterval = 0.3) {
    guard let navBar = findNavigationBar(),
          let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
    
    // 이미 있다면 스킵
    if keyWindow.viewWithTag(88888) != nil { return }
    
    let navBarHeight = navBar.frame.maxY
    let totalHeight = navBarHeight
    
    // 오버레이 추가
    let overlay = UIView(frame: CGRect(x: 0, y: 0, width: keyWindow.bounds.width, height: totalHeight))
    overlay.tag = 88888
    overlay.backgroundColor = color.withAlphaComponent(0)
    overlay.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
    overlay.isUserInteractionEnabled = false
    keyWindow.addSubview(overlay)
    
    // 애니메이션 적용
    UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear], animations: {
        overlay.backgroundColor = color
    })
  }
  
  static func removeOverlay(duration: TimeInterval = 0.3) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
          let overlay = keyWindow.viewWithTag(88888) else { return }
    
    UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear], animations: {
      overlay.alpha = 0
    }, completion: { _ in
      overlay.removeFromSuperview()
    })
  }
  
  private static func findNavigationBar() -> UINavigationBar? {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
          let navController = keyWindow.rootViewController?.findNavController() else { return nil }
    return navController.navigationBar
  }
}

extension UIViewController {
  func findNavController() -> UINavigationController? {
    if let nav = self as? UINavigationController {
      return nav
    }
    return children.compactMap { $0.findNavController() }.first
  }
}
