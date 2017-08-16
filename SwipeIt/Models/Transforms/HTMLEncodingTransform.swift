//
//  HTMLEncodingTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 08/06/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

open class HTMLEncodingTransform: TransformType {
  public typealias Object = String
  public typealias JSON = String

  public init() {}

  open func transformFromJSON(_ value: Any?) -> Object? {
    guard let value = value as? String else {
      return nil
    }
    return value.stringByDecodingHTMLEntities
  }

  open func transformToJSON(_ value: Object?) -> String? {
    return value
  }
}
