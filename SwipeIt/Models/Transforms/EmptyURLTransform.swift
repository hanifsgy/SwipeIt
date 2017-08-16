//
//  EmptyURLTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 25/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

open class EmptyURLTransform: TransformType {
  public typealias Object = URL
  public typealias JSON = String

  public init() {}

  open func transformFromJSON(_ value: Any?) -> URL? {
    if let URLString = value as? String, URLString.characters.count > 0 {
      return URL(string: URLString)
    }
    return nil
  }

  open func transformToJSON(_ value: URL?) -> String? {
    if let URL = value {
      return URL.absoluteString
    }
    return nil
  }
}
