//
//  UITableView+Deselect.swift
//  Reddit
//
//  Created by Ivan Bruel on 11/07/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

extension UITableView {

  func deselectRows(_ animated: Bool) {
    indexPathsForSelectedRows?.forEach {
      self.deselectRow(at: $0, animated: animated)
    }
  }
}
