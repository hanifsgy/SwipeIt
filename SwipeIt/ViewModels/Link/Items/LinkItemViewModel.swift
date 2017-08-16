//
//  LinkItemViewModel.swift
//  Reddit
//
//  Created by Ivan Bruel on 09/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import RxSwift
import DateToolsSwift
import RxTimer
import TTTAttributedLabel

class LinkItemViewModel: ViewModel {

  // MARK: Private
  fileprivate let user: User
  fileprivate let accessToken: AccessToken
  fileprivate let vote: Variable<Vote>
  fileprivate let saved: Variable<Bool>
  fileprivate let showSubreddit: Bool

  // MARK: Protected
  let disposeBag: DisposeBag = DisposeBag()
  let link: Link

  // MARK: Calculated Properties
  var title: String {
    return link.title
  }

  var url: URL {
    return link.url as URL
  }

  // MARK: Private Observables
  fileprivate var timeAgo: Observable<NSAttributedString> {
    return Observable
      .combineLatest(Observable.just(link.created), Timer.rx_timer) { ($0, $1) }
      .map { (created, _) -> String in
        created.shortTimeAgoSinceNow
      }.distinctUntilChanged()
      .map { NSAttributedString(string: $0) }
  }

  fileprivate var subredditName: Observable<NSAttributedString?> {
    return Observable.just(showSubreddit ? NSAttributedString(string: link.subreddit,
      attributes: [NSLinkAttributeName: link.subredditURL]) : nil)
  }

  fileprivate var author: Observable<NSAttributedString> {
    return Observable.just(NSAttributedString(string: link.author,
      attributes: [NSLinkAttributeName: link.authorURL]))
  }

  // MARK: Observables
  var context: Observable<NSAttributedString?> {
    return Observable
      .combineLatest(timeAgo, subredditName, author) {
        let result: [NSAttributedString?] = [$0, $1, $2]
        return result.flatMap { $0 }
      }.map { (attributedStrings: [NSAttributedString]) in
        return attributedStrings.joined(separator: " ● ")
    }
  }

  var comments: Observable<NSAttributedString> {
    let comments = link.totalComments > 1 ? L10n.Link.comments : L10n.Link.comments
    return .just(NSAttributedString(string: "\(link.totalComments) \(comments)"))
  }

  var commentsIcon: Observable<UIImage> {
    return .just(UIImage(asset: .CommentsGlyph))
  }

  var save: Observable<String> {
    return saved.asObservable()
      .map { $0 ? L10n.Link.unsave : L10n.Link.save }
  }

  var score: Observable<NSAttributedString> {
    return Observable
      .combineLatest(Observable.just(link), vote.asObservable()) { ($0, $1) }
      .map { (link, vote) in
        let score = link.hideScore == true ? L10n.Link.Score.hidden : "\(link.scoreWithVote(vote))"
        switch vote {
        case .downvote:
          return NSAttributedString(string: score,
            attributes: [NSForegroundColorAttributeName: UIColor(named: .purple)])
        case .upvote:
          return NSAttributedString(string: score,
            attributes: [NSForegroundColorAttributeName: UIColor(named: .orange)])
        default:
          return NSAttributedString(string: score)
        }
    }
  }

  var scoreIcon: Observable<UIImage> {
    return  vote.asObservable()
      .map { vote in
        switch vote {
        case .downvote:
          return UIImage(asset: .DownvotedGlyph)
        case .upvote:
          return UIImage(asset: .UpvotedGlyph)
        case .none:
          return UIImage(asset: .NotVotedGlyph)
        }
    }
  }

  // MARK: Initializer
  init(user: User, accessToken: AccessToken, link: Link, showSubreddit: Bool) {
    self.user = user
    self.accessToken = accessToken
    self.link = link
    self.vote = Variable(link.vote)
    self.showSubreddit = showSubreddit
    self.saved = Variable(link.saved)
  }

  // MARK: API
  func preloadData() {
    // Nothing to preload in here
  }

  func upvote(_ completion: @escaping (Error?) -> Void) {
    voteLink(vote: .upvote, completion: completion)
  }

  func downvote(_ completion: @escaping (Error?) -> Void) {
    voteLink(vote: .downvote, completion: completion)
  }

  func unvote() {
    voteLink(vote: .none)
  }

  func toggleSave(_ completion: @escaping (Error?) -> Void) {
    saveLink(completion: completion)
  }

  func sendReport(_ reason: String, completion: @escaping (Error?) -> Void) {
    report(reason, completion: completion)
  }
}

// MARK: Network
extension LinkItemViewModel {

  fileprivate func report(_ reason: String, completion: ((Error?) -> Void)? = nil) {
    Network.request(.report(token: accessToken.token, identifier: link.name,
      reason: reason))
      .subscribe { event in
        switch event {
        case .error(let error):
          completion?(error)
        case .next:
          completion?(nil)
        default: break
        }
      }.addDisposableTo(disposeBag)
  }

  fileprivate func saveLink(completion: ((Error?) -> Void)? = nil) {
    let oldSaved = self.saved.value
    self.saved.value = !oldSaved
    let request = oldSaved ? RedditAPI.unsave(token: accessToken.token, identifier: link.name) :
      RedditAPI.save(token: accessToken.token, identifier: link.name)
    Network.request(request)
      .subscribe { [weak self] event in
        switch event {
        case .error(let error):
          self?.saved.value = oldSaved
          completion?(error)
        case .next:
          completion?(nil)
        default: break
        }
      }.addDisposableTo(disposeBag)
  }

  fileprivate func voteLink(vote: Vote, completion: ((Error?) -> Void)? = nil) {
    let oldVote = self.vote.value
    self.vote.value = vote
    Network.request(.vote(token: accessToken.token, identifier: link.name,
      direction: vote.rawValue))
      .subscribe { [weak self] event in
        switch event {
        case .error(let error):
          self?.vote.value = oldVote
          completion?(error)
        case .next:
          completion?(nil)
        default: break
        }
      }.addDisposableTo(disposeBag)
  }
}

// MARK: Helpers
extension LinkItemViewModel {

  static func viewModelFromLink(_ link: Link, user: User, accessToken: AccessToken,
                                subredditOnly: Bool) -> LinkItemViewModel {
    switch link.type {
    case .video:
      return LinkItemVideoViewModel(user: user, accessToken: accessToken, link: link,
                                    showSubreddit: !subredditOnly)
    case .image, .gif, .album:
      return LinkItemImageViewModel(user: user, accessToken: accessToken, link: link,
                                    showSubreddit: !subredditOnly)
    case .selfPost:
      return LinkItemSelfPostViewModel(user: user, accessToken: accessToken, link: link,
                                       showSubreddit: !subredditOnly)
    case .linkPost:
      return LinkItemLinkViewModel(user: user, accessToken: accessToken, link: link,
                                   showSubreddit: !subredditOnly)
    }
  }
}
