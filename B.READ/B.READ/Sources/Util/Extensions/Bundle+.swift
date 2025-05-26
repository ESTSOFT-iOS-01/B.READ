//
//  Bundle+.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

extension Bundle {
  
  static let ALAN_CLIENT_ID: String = {
    value(forKey: "ALAN_CLIENT_ID", fromPlistNamed: "APIKey")
  }()
  
  static let ALAN_BASE_URL: String = {
    value(forKey: "ALAN_BASE_URL", fromPlistNamed: "APIUrl")
  }()
  
  static let ALADIN_TTB_KEY: String = {
    value(forKey: "ALADIN_TTB_KEY", fromPlistNamed: "APIKey")
  }()
  
  static let ALADIN_BASE_URL: String = {
    value(forKey: "ALADIN_BASE_URL", fromPlistNamed: "APIUrl")
  }()
  
  private static func value<T>(forKey key: String, fromPlistNamed name: String) -> T {
    guard let filePath = Bundle.main.path(forResource: name, ofType: "plist"),
          let plist = NSDictionary(contentsOfFile: filePath),
          let value = plist[key] as? T else {
      fatalError("Couldn't find key '\(key)' in '\(name).plist'")
    }
    return value
  }
}
