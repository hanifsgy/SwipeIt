//
//  ListingType+Name.swift
//  Reddit
//
//  Created by Ivan Bruel on 05/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

extension ListingType {

  var name: String {
    switch self {
    case .hot:
      return L10n.Listingtype.hot
    case .new:
      return L10n.Listingtype.new
    case .rising:
      return L10n.Listingtype.rising
    case .controversial:
      return L10n.Listingtype.controversial
    case .top:
      return L10n.Listingtype.top
    case .gilded:
      return L10n.Listingtype.gilded
    }
  }

  static var names: [String] {
    return [L10n.Listingtype.hot, L10n.Listingtype.new, L10n.Listingtype.rising,
            L10n.Listingtype.controversial, L10n.Listingtype.top]
    //tr(.ListingTypeGilded)] Removed until comments are added
  }

}

extension ListingTypeRange {

  static var names: [String] {
    return [L10n.Listingtype.Range.hour, L10n.Listingtype.Range.day, L10n.Listingtype.Range.week,
            L10n.Listingtype.Range.month, L10n.Listingtype.Range.year, L10n.Listingtype.Range.allTime]
  }
}
