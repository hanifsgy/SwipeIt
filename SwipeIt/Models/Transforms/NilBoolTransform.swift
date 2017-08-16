//
//  NilBoolTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 27/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

open class NilBoolTransform: TransformType {
  public typealias Object = Bool
  public typealias JSON = Bool

  public init() {}

  open func transformFromJSON(_ value: Any?) -> Object? {
    guard let value = value as? Object else {
      return false
    }
    return value
  }

  open func transformToJSON(_ value: Object?) -> JSON? {
    return value
  }
}
