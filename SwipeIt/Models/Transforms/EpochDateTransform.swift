//
//  EpochDateTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 07/03/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

class EpochDateTransform: TransformType {
  typealias Object = Date
  typealias JSON = Int

  init() {}

  func transformFromJSON(_ value: Any?) -> Object? {
    guard let value = value as? Int else {
      return nil
    }
    return Date(timeIntervalSince1970: Double(value))
  }

  func transformToJSON(_ value: Object?) -> JSON? {
    return value.flatMap { Int($0.timeIntervalSince1970) }
  }
}
