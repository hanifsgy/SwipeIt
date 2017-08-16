//
//  PermalinkTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 27/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

open class PermalinkTransform: TransformType {
  public typealias Object = URL
  public typealias JSON = String

  public init() {}

  open func transformFromJSON(_ value: Any?) -> Object? {
    guard let value = value as? String else {
      return nil
    }
    let fullPermalink = "\(Constants.redditURL)\(value)"
    return URL(string: fullPermalink)
  }

  open func transformToJSON(_ value: Object?) -> String? {
    return value?.absoluteString
  }
}
