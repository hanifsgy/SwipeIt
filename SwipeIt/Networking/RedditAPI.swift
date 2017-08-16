//
//  RedditAPI.swift
//  Reddit
//
//  Created by Ivan Bruel on 02/03/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import Moya

enum RedditAPI {

  case accessToken(code: String, redirectURL: String, clientId: String)
  case refreshToken(refreshToken: String, clientId: String)
  case subredditListing(token: String, after: String?)
  case defaultSubredditListing(after: String?)
  case multiredditListing(token: String)
  case linkDetails(token: String, permalink: String)
  case linkListing(token: String, path: String, listingPath: String, listingTypeRange: String?,
    after: String?)
  case userDetails(token: String, username: String)
  case userMeDetails(token: String)
  case vote(token: String, identifier: String, direction: Int)
  case save(token: String, identifier: String)
  case unsave(token: String, identifier: String)
  case report(token: String, identifier: String, reason: String)

}

extension RedditAPI: TargetType {

  var task: Task {
    return .request
  }

  var baseURL: URL {
    guard token != nil else {
      return URL(string: "https://www.reddit.com")!
    }
    return URL(string: "https://oauth.reddit.com")!
  }

  var path: String {
    switch self {
    case .accessToken, .refreshToken:
      return "/api/v1/access_token"
    case .multiredditListing:
      return "/api/multi/mine"
    case .subredditListing:
      return "/subreddits/mine"
    case .defaultSubredditListing:
      return "/subreddits/default"
    case .linkListing(_, let path, let listingPath, _, _):
      return "\(path)\(listingPath)"
    case .linkDetails(_, let permalink):
      return permalink
    case .userMeDetails(_):
      return "/api/v1/me"
    case .userDetails(_, let username):
      return "/user/\(username)/about"
    case .vote:
      return "/api/vote"
    case .save:
      return "/api/save"
    case .unsave:
      return "/api/unsave"
    case .report:
      return "/api/report"
    }
  }

  var method: Moya.Method {
    switch self {
    case .accessToken, .refreshToken, .vote, .save, .unsave, .report:
      return .post
    default:
      return .get
    }
  }

  var parameters: [String: Any]? {
    switch self {
    case .accessToken(let code, let redirectURL, _):
      return [
        "grant_type": "authorization_code" as AnyObject,
        "code": code as AnyObject,
        "redirect_uri": redirectURL as AnyObject]
    case .refreshToken(let refreshToken, _):
      return [
        "grant_type": "refresh_token" as AnyObject,
        "refresh_token": refreshToken as AnyObject
      ]
    case .subredditListing(_, let after):
      guard let after = after else {
        return nil
      }
      return ["after": after as AnyObject]
    case .defaultSubredditListing(let after):
      guard let after = after else {
        return nil
      }
      return ["after": after as AnyObject]
    case .linkListing(_, _, _, let listingTypeRange, let after):
      guard let after = after else {
        return nil
      }
      return JSONHelper.flatJSON(["after": after, "t": listingTypeRange])
    case .vote(_, let identifier, let direction):
      return ["id": identifier as AnyObject, "dir": direction as AnyObject]
    case .save(_, let identifier):
      return ["id": identifier as AnyObject]
    case .unsave(_, let identifier):
      return ["id": identifier as AnyObject]
    case .report(_, let identifier, let reason):
      return ["thing_id": identifier as AnyObject, "reason": reason as AnyObject]
    default:
      return nil
    }
  }

  var sampleData: Data {
    switch self {
    case .accessToken, .refreshToken:
      return JSONReader.readJSONData("AccessToken")
    case .subredditListing:
      return JSONReader.readJSONData("SubredditListing")
    case .defaultSubredditListing:
      return JSONReader.readJSONData("SubredditListing")
    case .linkListing:
      return JSONReader.readJSONData("LinkListing")
    case .multiredditListing:
      return JSONReader.readJSONData("MultiredditListing")
    case .linkDetails:
      return JSONReader.readJSONData("LinkDetails")
    case .userDetails, .userMeDetails:
      return JSONReader.readJSONData("UserDetails")
    case .vote:
      return JSONReader.readJSONData("Upvoted")
    default:
      return Data()
    }
  }

  var headers: [String: String]? {
    guard let token = token else {
      return nil
    }
    return ["Authorization": "bearer \(token)"]
  }

  var parameterEncoding: ParameterEncoding {
    switch self {
    case .accessToken, .refreshToken:
      return URLEncoding.default
    case .vote, . save, .unsave, .report:
      return URLEncoding.default //TODO really?
    default:
      return method == .get ? URLEncoding.default : JSONEncoding.default
    }
  }

  var token: String? {
    switch self {
    case .subredditListing(let token, _):
      return token
    case .linkListing(let token, _, _, _, _):
      return token
    case .multiredditListing(let token):
      return token
    case .linkDetails(let token, _):
      return token
    case .userDetails(let token, _):
      return token
    case .userMeDetails(let token):
      return token
    case .vote(let token, _, _):
      return token
    case .save(let token, _):
      return token
    case .unsave(let token, _):
      return token
    case .report(let token, _, _):
      return token
    default:
      return nil
    }
  }

  var url: String {
    return "\(baseURL)\(path).json"
  }

  var multipartBody: [MultipartFormData]? {
    return nil
  }

  var credentials: URLCredential? {
    switch self {
    case .accessToken(_, _, let clientId):
      return URLCredential(user: clientId, password: "", persistence: .none)
    case .refreshToken(_, let clientId):
      return URLCredential(user: clientId, password: "", persistence: .none)
    default:
      return nil
    }
  }

}
