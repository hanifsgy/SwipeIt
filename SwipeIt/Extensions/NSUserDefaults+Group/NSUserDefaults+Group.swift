//
//  NSUserDefaults+Group.swift
//  Reddit
//
//  Created by Ivan Bruel on 06/06/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

extension UserDefaults {

  /// The suite name for the app group
  fileprivate static let suiteName = "group.vc.faber.Reddit"

  /// Accessor to the suite's NSUserDefaults
  static var userDefaults: UserDefaults {
    return UserDefaults(suiteName: suiteName) ?? .standard
  }
}
