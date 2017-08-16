//
//  ClosedInterval+Clamp.swift
//  Reddit
//
//  Created by Ivan Bruel on 22/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

extension ClosedRange {

  func clamp(_ value: Bound) -> Bound {
    return self.lowerBound > value ? self.lowerBound
      : self.upperBound < value ? self.upperBound
      : value
  }
}
