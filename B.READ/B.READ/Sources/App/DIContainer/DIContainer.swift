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
    
    // MARK: - Repository 생성
    let userInfoRepository = UserInfoRepositoryImpl(modelContainer: storage.modelContainer)
    let bookRepository = BookRepositoryImpl(modelContainer: storage.modelContainer)
    let recordRepository = RecordRepositoryImpl(modelContainer: storage.modelContainer)
    let memoRepository = MemoRepositoryImpl(modelContainer: storage.modelContainer)
    let quoteRepository = QuoteRepositoryImpl(modelContainer: storage.modelContainer)
    let aiService = AlanService()
    
    // MARK: - UseCase 생성 및 등록
    // Profile UseCase
    self.shared.register(
      ProfileUseCaseImpl(userInfoRepository: userInfoRepository),
      for: ProfileUseCase.self
    )
    // Library UseCase
    self.shared.register(
      LibraryUseCaseImpl(
        bookRepository: bookRepository,
        recordRepository: recordRepository,
        quoteRepository: quoteRepository,
        bookService: AladinService()
      ),
      for: LibraryUseCase.self
    )
    // TODO: - Memo UseCase
    self.shared.register(
      MemoUseCaseImpl(
        bookRepository: bookRepository,
        memoRepository: memoRepository,
        aiService: aiService
      ),
      for: MemoUseCase.self
    )
    // Quote UseCase
    self.shared.register(
      QuoteUseCaseImpl(
        quoteRepository: quoteRepository,
        bookRepository: bookRepository),
      for: QuoteUseCase.self
    )
    // TODO: - Note UseCase
    // TODO: - Search UseCase
    // TODO: - Recommand UseCase
  }
}
