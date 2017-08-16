//
//  MultiredditListViewModel.swift
//  Reddit
//
//  Created by Ivan Bruel on 06/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

// MARK: Properties and Initializer
class MultiredditListViewModel: ViewModel {

  typealias MultiredditListSectionViewModel = SectionViewModel<MultiredditListItemViewModel>

  // MARK: Private Properties
  fileprivate let user: User
  fileprivate let accessToken: AccessToken
  fileprivate let multireddits: Variable<[Multireddit]>
  fileprivate let disposeBag = DisposeBag()

  // 1. Map multireddits into their view model
  // 4. Create sections from the subreddit view models
  var viewModels: Observable<[MultiredditListSectionViewModel]> {
    return Observable.combineLatest(multireddits.asObservable(), userObservable,
    accessTokenObservable) { ($0, $1, $2) }
      .map { (multireddits, user, accessToken) in
        multireddits.map {
          MultiredditListItemViewModel(user: user, accessToken: accessToken, multireddit: $0)
        }
      }.map { multiredditViewModels in
        return MultiredditListViewModel.sectionsFromMultiredditViewModels(multiredditViewModels)
    }
  }

  init(user: User, accessToken: AccessToken) {
    self.user = user
    self.accessToken = accessToken

    multireddits = Variable([])
  }
}

// MARK: Private Observables
extension MultiredditListViewModel {

  fileprivate var userObservable: Observable<User> {
    return .just(user)
  }

  fileprivate var accessTokenObservable: Observable<AccessToken> {
    return .just(accessToken)
  }
}

// MARK: Networking
extension MultiredditListViewModel {

  func requestMultireddits() {
    Network.request(.multiredditListing(token: accessToken.token))
      .observeOn(SerialDispatchQueueScheduler(qos: .background))
      .mapArray(Multireddit.self)
      .observeOn(MainScheduler.instance)
      .bindNext { [weak self] multireddits in
        self?.multireddits.value = multireddits
      }.addDisposableTo(disposeBag)
  }
}

// MARK: Helpers
extension MultiredditListViewModel {

  // Extract first letters to create the alphabet, and create the sections afterwards
  fileprivate class func sectionsFromMultiredditViewModels(_ viewModels: [MultiredditListItemViewModel])
    -> [MultiredditListSectionViewModel] {

      return viewModels.map { $0.name.firstLetter }
        .unique()
        .sorted(by: Sorter.alphabetSort)
        .map { letter in
          let viewModels = viewModels
            .filter { $0.name.firstLetter == letter }
            .sorted { $0.0.name < $0.1.name }
          return SectionViewModel(title: letter, viewModels: viewModels)
      }
  }
}
