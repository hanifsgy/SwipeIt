//
//  NSAttributedString+Join.swift
//  Reddit
//
//  Created by Ivan Bruel on 05/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: NSAttributedString {
  func joined(separator: NSAttributedString = NSAttributedString(string: "")) -> NSAttributedString {
    var isFirst = true
    return self.reduce(NSMutableAttributedString()) { result, element in
      if isFirst {
        isFirst = false
      } else {
        result.append(separator)
      }
      result.append(element)
      return result
    }
  }

  func joined(separator: String = "") -> NSAttributedString {
    return joined(separator: NSAttributedString(string: separator))
  }
}
