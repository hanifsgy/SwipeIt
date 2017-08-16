//
//  String+Range.swift
//  Reddit
//
//  Created by Ivan Bruel on 15/07/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

extension String {

  func rangeFromNSRange(_ nsRange: NSRange) -> Range<String.Index>? {
    let fromUTF16 = utf16.index(utf16.startIndex, offsetBy: nsRange.length)
    let toUTF16 = utf16.index(fromUTF16, offsetBy: nsRange.length)

    if let from = String.Index(fromUTF16, within: self),
      let to = String.Index(toUTF16, within: self) {
      return from..<to
    }
    return nil
  }
}
