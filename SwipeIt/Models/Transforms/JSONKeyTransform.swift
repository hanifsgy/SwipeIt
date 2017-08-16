//
//  JSONKeyTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 28/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

open class JSONKeyTransform: TransformType {
  public typealias Object = [String]
  public typealias JSON = [[String: String]]

  fileprivate let key: String

  public init(_ key: String) {
    self.key = key
  }

  open func transformFromJSON(_ value: Any?) -> Object? {
    guard let value = value as? JSON else {
      return nil
    }
    return value.flatMap { $0[self.key] }
  }

  open func transformToJSON(_ value: Object?) -> JSON? {
    return value?.map { [self.key: $0] }
  }
}
