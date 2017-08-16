//
//  ImageSource.swift
//  Reddit
//
//  Created by Ivan Bruel on 07/03/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

struct ImageSource: Mappable {

  // MARK: Image
  var url: URL!
  var width: Int!
  var height: Int!

  var size: CGSize {
    return CGSize(width: width, height: height)
  }

  // MARK: JSON
  init?(map: Map) { }

  mutating func mapping(map: Map) {
    url <- (map["url"], EmptyURLTransform())
    width <- map["width"]
    height <- map["height"]
  }

}
