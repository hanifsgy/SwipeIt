//
//  Theming.swift
//  Reddit
//
//  Created by Ivan Bruel on 06/06/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import RxSwift

class Theming {

  static let sharedInstance = Theming()

  fileprivate let _theme: Variable<Theme>

  var theme: Observable<Theme> {
    return _theme.asObservable()
  }

  init(theme: Theme) {
    self._theme = Variable(theme)
  }

  fileprivate convenience init() {
    self.init(theme: Globals.theme ?? .light)
  }

  func setTheme(_ theme: Theme) {
    self._theme.value = theme
  }
}

// MARK: Colors
extension Theming {

  var textColor: Observable<UIColor> {
    return _theme.asObservable().map { $0.textColor }
  }

  var secondaryTextColor: Observable<UIColor> {
    return _theme.asObservable().map { $0.secondaryTextColor }
  }

  var accentColor: Observable<UIColor> {
    return _theme.asObservable().map { $0.accentColor }
  }

  var backgroundColor: Observable<UIColor> {
    return _theme.asObservable().map { $0.backgroundColor }
  }
}
