//
//  CoordinatorProtocol.swift
//  B.READ
//
//  Created by 김도연 on 5/21/25.
//

import SwiftUI

/// 화면 이동을 관리하는 네비게이션 프로토콜입니다.
/// `NavigationStack`을 기반으로 화면 push/pop 로직을 구현합니다.
protocol Navigatable: AnyObject {
  /// 화면 전환을 구분하는 열거형 타입입니다. Hashable을 준수해야 합니다.
  associatedtype AppScene: Hashable
  /// 각 페이지에서 렌더링할 SwiftUI View 타입입니다.
  associatedtype ContentView: View
  
  /// 현재 화면 스택의 경로를 나타냅니다.
  var path: [AppScene] { get set }
  
  /// 새로운 화면을 스택에 push하여 전환합니다.
  /// - Parameter page: 전환할 대상 화면의 열거형 값
  func push(_ page: AppScene)
  
  /// 현재 화면을 pop하여 이전 화면으로 되돌아갑니다.
  func pop()
  
  /// 스택의 모든 화면을 제거하고 루트 화면으로 돌아갑니다.
  func popToRoot()
  
  /// 주어진 화면 타입에 해당하는 View를 구성합니다.
  /// - Parameter page: 렌더링할 화면의 열거형 값
  /// - Returns: 해당 화면에 대응되는 SwiftUI View
  @ViewBuilder
  func buildPage(_ page: AppScene) -> ContentView
}

/// 모달 시트 형태의 화면 전환을 관리하는 프로토콜입니다.
/// `.sheet(item:)`을 기반으로 구현됩니다.
protocol SheetPresentable: AnyObject {
  /// 표시할 시트의 데이터 타입입니다. Identifiable을 준수해야 합니다.
  associatedtype Sheet: Identifiable
  /// 시트에서 보여줄 View 타입입니다.
  associatedtype SheetView: View
  
  /// 현재 표시 중인 시트입니다.
  var sheet: Sheet? { get set }
  
  /// 시트를 화면에 표시합니다.
  /// - Parameter sheet: 표시할 시트의 데이터
  func presentSheet(_ sheet: Sheet)
  
  /// 현재 표시 중인 시트를 닫습니다.
  func dismissSheet()
  
  /// 주어진 시트 데이터에 대한 View를 구성합니다.
  /// - Parameter sheet: 시트에 대응되는 데이터
  /// - Returns: 해당 시트에 대응되는 SwiftUI View
  @ViewBuilder
  func buildSheet(_ sheet: Sheet) -> SheetView
}

/// 풀스크린 화면 전환을 관리하는 프로토콜입니다.
/// `.fullScreenCover(item:)`을 기반으로 구현됩니다.
protocol FullScreenCoverPresentable: AnyObject {
  /// 표시할 풀스크린 커버의 데이터 타입입니다. Identifiable을 준수해야 합니다.
  associatedtype FullScreenCover: Identifiable
  /// 풀스크린 커버에서 보여줄 View 타입입니다.
  associatedtype FullScreenCoverView: View
  
  /// 현재 표시 중인 풀스크린 커버입니다.
  var fullScreenCover: FullScreenCover? { get set }
  
  /// 풀스크린 커버를 표시합니다.
  /// - Parameter cover: 표시할 커버의 데이터
  func presentFullScreenCover(_ cover: FullScreenCover)
  
  /// 현재 표시 중인 풀스크린 커버를 닫습니다.
  func dismissFullScreenCover()
  
  /// 주어진 풀스크린 커버 데이터에 대한 View를 구성합니다.
  /// - Parameter cover: 커버에 대응되는 데이터
  /// - Returns: 해당 커버에 대응되는 SwiftUI View
  @ViewBuilder
  func buildFullScreenCover(_ cover: FullScreenCover) -> FullScreenCoverView
}
