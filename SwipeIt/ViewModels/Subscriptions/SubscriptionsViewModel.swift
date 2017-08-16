//
//  SubscriptionsViewModel.swift
//  Reddit
//
//  Created by Ivan Bruel on 03/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import RxSwift

// MARK: Properties and Initializer
class SubscriptionsViewModel {

  // MARK: Public Properties
  var subredditListViewModel: SubredditListViewModel {
    return SubredditListViewModel(user: user, accessToken: accessToken)
  }

  var multiredditListViewModel: MultiredditListViewModel {
    return MultiredditListViewModel(user: user, accessToken: accessToken)
  }

  // MARK: Private Properties
  fileprivate let user: User
  fileprivate let accessToken: AccessToken

  // MARK: Initializer
  init(user: User, accessToken: AccessToken) {
    self.user = user
    self.accessToken = accessToken
  }

}

// MARK: TitledViewModel
extension SubscriptionsViewModel: TitledViewModel {

  var title: Observable<String> {
    return .just(L10n.Subscriptions.title)
  }
}
