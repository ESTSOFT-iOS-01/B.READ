//
//  StringArrayTransformer.swift
//  B.READ
//
//  Created by 김도연 on 5/30/25.
//

import Foundation

//@objc(StringArrayTransformer)
//final class StringArrayTransformer: ValueTransformer {
//  override class func transformedValueClass() -> AnyClass {
//    return NSData.self
//  }
//  
//  override class func allowsReverseTransformation() -> Bool {
//    return true
//  }
//  
//  override func transformedValue(_ value: Any?) -> Any? {
//      guard let array = value as? [String] else {
//          return try? JSONEncoder().encode("")
//      }
//      return try? JSONEncoder().encode(array)
//  }
//  
//  override func reverseTransformedValue(_ value: Any?) -> Any? {
//    guard let data = value as? Data else { return nil }
//    return try? JSONDecoder().decode([String].self, from: data)
//  }
//}
