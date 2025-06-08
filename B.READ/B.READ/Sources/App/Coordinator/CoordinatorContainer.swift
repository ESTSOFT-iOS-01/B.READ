//
//  CoordinatorContainer.swift
//  B.READ
//
//  Created by 신승재 on 5/25/25.
//

//import SwiftUI
//
//struct CoordinatorContainer<Content: View>: View {
//  
//  @StateObject private var coordinator = Coordinator<MainRoute, SheetRoute>()
//  @ObservedObject var rootCoordinator: RootCoordinator
//  
//  let content: () -> Content
//  
//  var body: some View {
//    NavigationStack(path: $rootCoordinator.paths) {
//      content()
//        .navigationDestination(for: FeatureRoute.self) { route in
//          switch route {
//          case .setting(let route):
//            EmptyView()
//            //settingCoordinator.buildView(for: route)
//          }
//        }
//    }
//    .environmentObject(rootCoordinator)
//    
//  }
//}
