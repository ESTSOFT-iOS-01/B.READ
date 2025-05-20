//
//  ResponseModel.swift
//  B.READ
//
//  Created by 신승재 on 5/20/25.
//

import Foundation

struct ResponseModel: Decodable {
  let action: Action
  let content: String
  
  struct Action: Decodable {
    let name: String
    let speak: String
  }
}
