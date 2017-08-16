//
//  LastElementTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 28/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

open class LastElementTransform<T: Mappable>: TransformType {
  public typealias Object = T
  public typealias JSON = [[String: Any]]

  public init() { }

  open func transformFromJSON(_ value: Any?) -> Object? {
    guard let value = value as? JSON,
      let json = value.last else {
      return nil
    }
    return Mapper<Object>().map(JSON: json)
  }

  open func transformToJSON(_ value: Object?) -> JSON? {
    guard let value = value else {
      return nil
    }
    return [Mapper<Object>().toJSON(value)]
  }
}
