//
//  Theme.swift
//  Reddit
//
//  Created by Ivan Bruel on 06/06/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

enum Theme: String {
  case light
  case dark

  var textColor: UIColor {
    switch self {
    case .light:
      return .darkText
    case .dark:
      return .lightText
    }
  }

  var secondaryTextColor: UIColor {
    switch self {
    case .light:
      return UIColor(named: .darkGray)
    case .dark:
      return UIColor(named: .lightGray)
    }
  }

  var accentColor: UIColor {
    switch self {
    default:
      return UIColor(named: .iosBlue)
    }
  }

  var backgroundColor: UIColor {
    switch self {
    case .light:
      return .white
    case .dark:
      return .darkGray
    }
  }
}
