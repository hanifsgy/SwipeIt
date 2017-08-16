//
//  Network.swift
//  Reddit
//
//  Created by Ivan Bruel on 02/03/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class Network {

  fileprivate static var provider = RxMoyaProvider<RedditAPI>(endpointClosure: { target -> Endpoint<RedditAPI> in
    return Endpoint<RedditAPI>(url: target.url,
                               sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                               method: target.method,
                               parameters: target.parameters,
                               parameterEncoding: target.parameterEncoding,
                               httpHeaderFields: target.headers)
  }, plugins: [
    NetworkLoggerPlugin(verbose: true, cURL: true, output: networkPrint, responseDataFormatter: jsonFormatter),
    credentialsPlugin
    ])

  fileprivate static var credentialsPlugin = CredentialsPlugin { target -> URLCredential? in
    guard let target = target as? RedditAPI else { return nil }
    return target.credentials
  }

  private static func jsonFormatter(data: Data) -> Data {
    do {
      let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
      return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    } catch {
      return data
    }
  }

  private static func networkPrint(separator: String, terminator: String, items: Any...) {
    items.forEach { item in
      print("\n\(String(describing: item))")
    }
  }
}

// MARK: Public Methods
extension Network {
  
  static func request(_ target: RedditAPI) -> Observable<Response> {
    return provider.request(target)
  }
}
