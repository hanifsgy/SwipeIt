//
//  SwipeViewController.swift
//  Reddit
//
//  Created by Ivan Bruel on 18/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import RxSwift
import ZLSwipeableViewSwift

class LinkSwipeViewController: UIViewController, CloseableViewController, AlerteableViewController {

  // MARK: - IBOutlets
  @IBOutlet fileprivate weak var swipeView: ZLSwipeableView!
  @IBOutlet fileprivate weak var downvoteButton: UIButton!
  @IBOutlet fileprivate weak var upvoteButton: UIButton!
  @IBOutlet fileprivate weak var undoButton: UIButton!
  @IBOutlet fileprivate weak var shareButton: UIButton!

  // MARK: - ViewModel
  var viewModel: LinkSwipeViewModel!

  // MARK: Properties
  fileprivate var cardIndex: Int = 0
  fileprivate lazy var shareHelper: ShareHelper = ShareHelper(viewController: self)
  fileprivate lazy var alertHelper: AlertHelper = AlertHelper(viewController: self)
}

// MARK: - Lifecycle
extension LinkSwipeViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    swipeView.nextView = { [weak self] in
      self?.swipeViewNextView()
    }
  }
}

// MARK: - Setup
extension LinkSwipeViewController {

  fileprivate func setup() {
    setupCloseButton()
    setupSwipeView()
    bindViewModel()
  }

  fileprivate func setupSwipeView() {
    swipeView.animateView = ZLSwipeableView.tinderAnimateViewHandler()
    swipeView.numberOfHistoryItem = 10
    swipeView.didTap = { [weak self] (view, location) in
      guard let linkCardView = view as? LinkCardView else { return }
      self?.swipeViewTapped(linkCardView, location: location)
    }
    swipeView.didSwipe = { [weak self] (view, direction, directionVector) in
      guard let linkCardView = view as? LinkCardView else { return }
      self?.swipeViewSwiped(linkCardView, inDirection: direction, directionVector: directionVector)
    }
    swipeView.didDisappear = { [weak self] view in
      guard let linkCardView = view as? LinkCardView else { return }
      self?.swipeViewDisappeared(linkCardView)
    }
    swipeView.swiping = { [weak self] (view, location, translation) in
      guard let linkCardView = view as? LinkCardView else { return }
      self?.swipeViewSwiping(linkCardView, atLocation: location, translation: translation)
    }
    swipeView.didCancel = { [weak self] view in
      guard let linkCardView = view as? LinkCardView else { return }
      self?.swipeViewDidCancelSwiping(linkCardView)
    }

    updateUndoButton()
  }

  fileprivate func bindViewModel() {
    viewModel.title
      .bindTo(rx.title)
      .addDisposableTo(rx_disposeBag)
    viewModel.requestLinks()
    viewModel.viewModels
      .subscribeNext { [weak self] _ in
        self?.swipeView.loadViews()
      }.addDisposableTo(rx_disposeBag)
  }

  fileprivate func updateUndoButton() {
    undoButton.isEnabled = swipeView.history.count != 0
  }
}

// MARK: IBActions
extension LinkSwipeViewController {

  @IBAction fileprivate func upvoteClick() {
    currentCardView?.animateOverlayPercentage(1)
    swipeView.swipeTopView(inDirection: .Right)
  }

  @IBAction fileprivate func downvoteClick() {
    currentCardView?.animateOverlayPercentage(-1)
    swipeView.swipeTopView(inDirection: .Left)
  }

  @IBAction fileprivate func undoClick() {
    guard swipeView.history.count > 0 else { return }
    currentCardView?.didDisappear()
    swipeView.rewind()
    cardIndex -= 1
    updateUndoButton()
    currentViewModel?.unvote()
    currentCardView?.didAppear()
  }

  @IBAction fileprivate func shareClick() {
    guard let viewModel = currentViewModel else { return }
    shareHelper.share(viewModel.title, URL: viewModel.url, image: nil, fromView: shareButton)
  }
}

// MARK: ZLSwipeableViewDelegate
extension LinkSwipeViewController {

  fileprivate func swipeViewNextView() -> UIView? {
    guard let viewModel = self.viewModel.viewModelForIndex(cardIndex) else {
      self.viewModel.requestLinks()
      return nil
    }

    let view: LinkCardView
    switch viewModel {
    case is LinkItemImageViewModel:
      view = LinkImageCardView(frame: swipeView.bounds)
    default:
      return nil
    }
    // First card never goes through the swipeViewSwipped(...)
    if cardIndex == 0 {
      view.didAppear()
    }
    cardIndex += 1
    view.viewModel = viewModel
    view.moreOptionsClicked = swipeViewDidClickMore
    return view
  }

  fileprivate func swipeViewSwiped(_ view: LinkCardView, inDirection: Direction,
                               directionVector: CGVector) {
    updateUndoButton()
    currentCardView?.didAppear()

    guard let viewModel = view.viewModel else {
      return
    }
    switch inDirection {
    case Direction.Left:
      viewModel.downvote { [weak self] error in
        self?.voteCompletion(error, view: view)
      }
    case Direction.Right:
      viewModel.upvote { [weak self] error in
        self?.voteCompletion(error, view: view)
      }
    default: break
    }

    if self.viewModel.viewModelForIndex(cardIndex + 4) == nil {
      self.viewModel.requestLinks()
    }
  }

  fileprivate func swipeViewTapped(_ view: LinkCardView, location: CGPoint) {

  }

  fileprivate func swipeViewDisappeared(_ view: LinkCardView) {
    view.didDisappear()
  }

  fileprivate func swipeViewSwiping(_ view: LinkCardView, atLocation: CGPoint, translation: CGPoint) {
    let offset = translation.x
    let direction: CGFloat = offset >= 0 ? 1 : -1
    let min: CGFloat = 20
    let max: CGFloat = 40
    let percentage: CGFloat = ((min ... max).clamp(abs(offset)) - min)/(max - min) * direction
    view.animateOverlayPercentage(percentage)
  }

  fileprivate func swipeViewDidCancelSwiping(_ view: LinkCardView) {
    view.animateOverlayPercentage(0)
  }

  fileprivate func swipeViewDidClickMore(_ view: LinkCardView) {
    guard let viewModel = view.viewModel else { return }
    viewModel.save.take(1)
      .subscribeNext { [weak self] save in
        let options = [save, L10n.Link.report, L10n.Link.openInSafari]
        self?.alertHelper.presentActionSheet(options: options) { index in
          guard let index = index else { return }
          switch index {
          case 0:
            viewModel.toggleSave { error in
            }
          case 1:
            self?.report(viewModel)
          case 2:
            self?.openInSafari(viewModel)
          default: break
          }
        }
      }.addDisposableTo(rx_disposeBag)
  }
}

// MARK: - Helpers
extension LinkSwipeViewController {

  fileprivate func openInSafari(_ viewModel: LinkItemViewModel) {
    UIApplication.shared.openURL(viewModel.url as URL)
  }

  fileprivate func report(_ viewModel: LinkItemViewModel) {
    let reasons: [String] = [L10n.Link.Report.spam, L10n.Link.Report.voteManipulation,
                             L10n.Link.Report.personalInfo, L10n.Link.Report.sexualizingMinors,
                             L10n.Link.Report.breakingReddit, L10n.Link.Report.other]
    alertHelper.presentActionSheet(options: reasons) { [weak self] index in
      guard let index = index else { return }
      guard index != 5 else {
        self?.reportOtherReason(viewModel)
        return
      }
      self?.reportWithReason(reasons[index], viewModel: viewModel)
    }
  }

  fileprivate func reportOtherReason(_ viewModel: LinkItemViewModel) {
    let textfield = AlertTextField(text: nil, placeholder: L10n.Link.Report.Other.hint)
    presentAlert(L10n.Link.report, message: L10n.Link.Report.Other.reason,
                 textField: textfield, buttonTitle: L10n.Link.report,
                 cancelButtonTitle: L10n.Alert.Button.cancel) { [weak self] alertClicked in
                  switch alertClicked {
                  case let .buttonWithText(reason):
                    self?.reportWithReason(reason, viewModel: viewModel)
                  default: return
                  }
    }
  }

  fileprivate func reportWithReason(_ reason: String?, viewModel: LinkItemViewModel) {
    guard let reason = reason else { return }
    viewModel.sendReport(reason) { error in
    }
  }

  fileprivate func voteCompletion(_ error: Error?, view: UIView) {
    guard let _ = error, swipeView.history.last == view else {
      return
    }
    currentCardView?.didDisappear()
    swipeView.rewind()
  }

  fileprivate var currentViewModel: LinkItemViewModel? {
    return (swipeView.topView() as? LinkCardView)?.viewModel
  }

  fileprivate var currentCardView: LinkCardView? {
    return swipeView.topView() as? LinkCardView
  }
}
