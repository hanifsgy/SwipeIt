//
//  WalkthroughViewController.swift
//  Reddit
//
//  Created by Ivan Bruel on 25/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

// MARK: Properties and Lifecycle
class WalkthroughViewController: UIViewController {

  var viewModel: WalkthroughViewModel! = WalkthroughViewModel()

  @IBOutlet fileprivate weak var loginButton: UIButton! {
    didSet {
      loginButton.setTitle(L10n.Walkthrough.Button.login, for: .normal)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

}

// MARK: Setup
extension WalkthroughViewController {

  fileprivate func setup() {
    viewModel.loginResult
      .bindNext { [weak self] error in
        guard let error = error else {
          self?.goToMainStoryboard()
          return
        }
        self?.showLoginError(error)
      }.addDisposableTo(self.rx_disposeBag)
  }

}

// MARK: UI
extension WalkthroughViewController: AlerteableViewController {

  fileprivate func goToMainStoryboard() {
    perform(segue: StoryboardSegue.Onboarding.main, sender: nil)
  }

  fileprivate func showLoginError(_ error: Error) {
    let loginError = error as? LoginError ?? .unknown
    presentAlert(L10n.Login.Error.title, message: loginError.description,
                 buttonTitle: L10n.Alert.Button.ok)
  }

}

// MARK: Segue
extension WalkthroughViewController {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let rootViewController = segue.navigationRootViewController else {
      return
    }

    switch rootViewController {
    case let loginViewController as LoginViewController:
      loginViewController.viewModel = viewModel.loginViewModel
    case let subscriptionsViewController as SubscriptionsViewController:
      subscriptionsViewController.viewModel = viewModel.subscriptionsViewModel
    default:
      return
    }
  }

}
