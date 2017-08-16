//
//  MediaEmbed.swift
//  Reddit
//
//  Created by Ivan Bruel on 07/03/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

struct EmbeddedMedia: Mappable {

  // MARK: EmbeddedMedia
  var content: String!
  var scrolling: Bool!
  var width: Int!
  var height: Int!

  // MARK: JSON
  init?(map: Map) {
    guard map.JSON.count > 0 else {
      return nil
    }
  }

  mutating func mapping(map: Map) {
    content <- map["content"]
    scrolling <- map["scrolling"]
    width <- map["width"]
    height <- map["height"]
  }

}
