//
//  LinkVideoCarView.swift
//  SwipeIt
//
//  Created by Ivan Bruel on 13/09/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import TextStyle
import WebKit
import TTTAttributedLabel

class LinkVideoCardView: LinkCardView {

  override var viewModel: LinkItemViewModel? {
    didSet {
      guard let videoViewModel = viewModel as? LinkItemVideoViewModel,
        videoHTML = videoViewModel.videoHTML else { return }
      webView.loadHTMLString(videoHTML, baseURL: nil)
    }
  }


  // MARK: - Views
  private lazy var webView: WKWebView = self.createWebView()

  // MARK - Initializers
  override init() {
    super.init(frame: .zero)
    commonInit()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  private func commonInit() {
    contentView = webView
  }

  override func didAppear() {
    super.didAppear()
  }

  override func didDisappear() {
    super.didDisappear()
  }
}

extension LinkVideoCardView {

  private func createWebView() -> WKWebView {
    let config = WKWebViewConfiguration()
    let bodyStyle = "body { margin:0; }"
    let source = "var node = document.createElement(\"style\"); " +
      "node.innerHTML = \"\(bodyStyle)\";document.body.appendChild(node);"

    let script = WKUserScript(
      source: source,
      injectionTime: .AtDocumentEnd,
      forMainFrameOnly: false
    )

    config.userContentController.addUserScript(script)
    let webView = WKWebView(frame: .zero, configuration: config)
    webView.scrollView.scrollEnabled = false
    return webView
  }

}
