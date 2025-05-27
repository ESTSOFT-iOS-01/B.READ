//
//  DIContainer.swift
//  B.READ
//
//  Created by 신승재 on 5/26/25.
//

import Foundation

final class DIContainer {
  
  static let shared = DIContainer()
  
  private var dependencies = [String: Any]()
  
  private init() {}
  
  func register<T>(_ dependency: T, for type: T.Type) {
    let key = String(describing: type)
    dependencies[key] = dependency
  }
  
  func resolve<T>(_ type: T.Type) -> T {
    let key = String(describing: type)
    guard let dependency = dependencies[key] else {
      preconditionFailure("\(key)는 register되지 않았어요. resolve 부르기 전에 register 해주세요")
    }
    return dependency as! T
  }
}


@propertyWrapper
class Dependency<T> {
  let wrappedValue: T
  
  init() {
    self.wrappedValue = DIContainer.shared.resolve(T.self)
  }
}

extension DIContainer {
  static func config() async {
    let storage = SwiftDataStorage()
    let userInfoRepository = UserInfoRepositoryImpl(modelContainer: storage.modelContainer)
    self.shared.register(
      ProfileUseCaseImpl(userInfoRepository: userInfoRepository),
      for: ProfileUseCase.self
    )
  }
}
