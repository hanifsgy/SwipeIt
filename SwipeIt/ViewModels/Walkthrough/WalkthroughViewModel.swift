//
//  WalkthroughViewModel.swift
//  Reddit
//
//  Created by Ivan Bruel on 26/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import RxSwift
import Result
import RxResult

// MARK: Properties and initializers
class WalkthroughViewModel: ViewModel {

  // MARK: Public Properties
  var loginResult: Observable<LoginError?> {
    return loginViewModel.loginResult
      .doOnSuccess { [weak self] accessToken in
        self?.accessToken = accessToken
      }.flatMap { result -> Observable<Result<User, LoginError>> in
        switch result {
        case .success(let accessToken):
          return WalkthroughViewModel.getUserDetails(accessToken)
            .map { Result(value: $0) }
        case .failure(let error):
          return .just(Result(error: error))
        }

      }.doOnSuccess { [weak self] user in
        self?.user = user
      }.map { $0.error }
  }

  var loginViewModel = LoginViewModel()

  var subscriptionsViewModel: SubscriptionsViewModel? {
    guard let user = user, let accessToken = accessToken else { return nil }
    return SubscriptionsViewModel(user: user, accessToken: accessToken)
  }

  // MARK: Private Properties
  fileprivate var accessToken: AccessToken?
  fileprivate var user: User?

}

// MARK: Networking
extension WalkthroughViewModel {

  // Object isn't wrapped in a data object as opposed to all other endpoints
  fileprivate static func getUserDetails(_ accessToken: AccessToken) -> Observable<User> {
    return Network.request(.userMeDetails(token: accessToken.token))
      .observeOn(SerialDispatchQueueScheduler(qos: .background))
      .mapObject(User.self) { json in
        guard let jsonObject = json else {
          return json
        }
        return [
          "kind": "t2",
          "data": jsonObject
        ]
      }.observeOn(MainScheduler.instance)
  }
}
