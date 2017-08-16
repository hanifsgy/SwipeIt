//
//  AccessToken.swift
//  Reddit
//
//  Created by Ivan Bruel on 26/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

struct AccessToken: Mappable {

  // MARK: AccessToken
  var token: String!
  var tokenType: String!
  var expirationDate: Date?
  var scope: String!
  var refreshToken: String?
  var created: Date! {
    didSet {
      if created == nil {
        created = Date()
      }
    }
  }

  // Custom initializer for reusing the refresh token with new AccessTokens from the RefreshToken
  // API.
  init(accessToken: AccessToken, refreshToken: String) {
    self.token = accessToken.token
    self.tokenType = accessToken.tokenType
    self.expirationDate = accessToken.expirationDate
    self.scope = accessToken.scope
    self.refreshToken = refreshToken
    self.created = accessToken.created
  }

  // Checks if the token is valid according to the expiration date
  var tokenIsValid: Bool {
    guard let expirationDate = expirationDate else {
      return false
    }
    return expirationDate.compare(Date()) == .orderedDescending
  }

  // MARK: JSON
  init?(map: Map) {
    guard let _ = map.JSON["access_token"] else {
      return nil
    }
  }

  mutating func mapping(map: Map) {
    created <- (map["created_at"], EpochDateTransform())
    token <- map["access_token"]
    tokenType <- map["token_type"]
    expirationDate <- (map["expires_in"], NowDateTransform(now: created))
    scope <- map["scope"]
    refreshToken <- map["refresh_token"]
  }
}
