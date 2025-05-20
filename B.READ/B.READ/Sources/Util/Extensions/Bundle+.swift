//
//  Bundle+.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

extension Bundle {
  static let ALAN_CLIENT_ID: String = {
    guard let filePath = Bundle.main.path(forResource: "APIKey", ofType: "plist") else {
      fatalError("Couldn't find file 'APIKey.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    
    guard let value = plist?.object(forKey: "ALAN_CLIENT_ID") as? String else {
      fatalError("Couldn't find key 'ALAN_CLIENT_ID' in 'APIKey.plist'.")
    }
    return value
  }()
}
