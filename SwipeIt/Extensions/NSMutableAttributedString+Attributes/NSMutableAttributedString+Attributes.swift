//
//  NSMutableAttributedString+Attributes.swift
//  Reddit
//
//  Created by Ivan Bruel on 05/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

extension NSAttributedString {

  var range: NSRange {
    return NSRange(location: 0, length: length)
  }

}

extension NSMutableAttributedString {

  func setFont(_ font: UIFont) {
    addAttribute(NSFontAttributeName, value: font, range: range)
  }

  func setTextColor(_ textColor: UIColor) {
    addAttribute(NSForegroundColorAttributeName, value: textColor, range: range)
  }

  func setLineSpacing(_ lineSpacing: CGFloat) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
  }

  func replaceAttribute(_ attributeName: String, attributes: [String: AnyObject]) {
    enumerateAttribute(attributeName, in: range, options: []) {
      (value, range, _) in
      guard let _ = value else { return }
      self.removeAttribute(attributeName, range: range)
      self.addAttributes(attributes, range: range)
    }
  }
}
