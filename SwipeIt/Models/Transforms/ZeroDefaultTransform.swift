//
//  ZeroDefaultTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 27/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

open class ZeroDefaultTransform: TransformType {
  public typealias Object = Int
  public typealias JSON = Int

  public init() {}

  open func transformFromJSON(_ value: Any?) -> Object? {
    guard let value = value as? Int else {
      return 0
    }
    return value
  }

  open func transformToJSON(_ value: Object?) -> Int? {
    return value
  }
}
