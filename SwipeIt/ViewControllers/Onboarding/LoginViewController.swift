//
//  LoginViewController.swift
//  Reddit
//
//  Created by Ivan Bruel on 25/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

// MARK: Properties and Lifecycle
class LoginViewController: WebViewController, CloseableViewController,
TitledViewModelViewController {

  var viewModel: LoginViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
  }

}

// MARK: Setup
extension LoginViewController {

  fileprivate func setup() {
    setupWebView()
    setupCloseButton()
    bindTitle(viewModel)
  }

  fileprivate func setupWebView() {
    loadURL(viewModel.oauthURLString)
  }

}

// MARK: WKNavigationDelegate
extension LoginViewController {

  func webView(_ webView: WKWebView,
               decidePolicyForNavigationAction navigationAction: WKNavigationAction,
                                               decisionHandler: (WKNavigationActionPolicy) -> Void) {
    guard let URLString = navigationAction.request.url?.absoluteString else { return }
    if viewModel.isRedirectURL(URLString) {
      decisionHandler(WKNavigationActionPolicy.cancel)
      dismiss(animated: true) {
        self.viewModel.loginWithRedirectURL(URLString)
      }
      return
    }
    decisionHandler(WKNavigationActionPolicy.allow)
  }

}
