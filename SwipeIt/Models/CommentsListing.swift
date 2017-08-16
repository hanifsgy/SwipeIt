//
//  CommentsListing.swift
//  Reddit
//
//  Created by Ivan Bruel on 27/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

struct CommentsListing: Mappable, Listing {

  // MARK: Listing
  var before: String?
  var after: String?

  // MARK: CommentsListing
  var comments: [Comment]?
  var moreComments: MoreComments?

  // MARK: JSON
  init?(map: Map) { }

  mutating func mapping(map: Map) {
    mappingListing(map)
    comments <- map["data.children"]
    moreComments <- (map["data.children"], LastElementTransform())
  }

}
