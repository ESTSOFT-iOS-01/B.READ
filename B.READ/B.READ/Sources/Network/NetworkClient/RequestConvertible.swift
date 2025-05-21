//
//  RequestConvertible.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

protocol RequestConvertible {
  func asURLRequest() throws -> URLRequest
}
