//
//  HideableHairlineViewController.swift
//  Reddit
//
//  Created by Ivan Bruel on 02/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

protocol HideableHairlineViewController {

  func hideHairline()
  func showHairline()

}

extension HideableHairlineViewController where Self: UIViewController {

  func hideHairline() {
    findHairline()?.isHidden = true
  }

  func showHairline() {
    findHairline()?.isHidden = false
  }

  fileprivate func findHairline() -> UIImageView? {
    return navigationController?.navigationBar.subviews
      .flatMap { (view: UIView) -> [UIView] in view.subviews }
      .flatMap { (view: UIView) -> UIImageView? in view as? UIImageView }
      .filter { $0.bounds.size.width == self.navigationController?.navigationBar.bounds.size.width }
      .filter { $0.bounds.size.height <= 2 }
      .first
  }

}
