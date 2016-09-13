//
//  LinkSelfCardView.swift
//  SwipeIt
//
//  Created by Ivan Bruel on 12/09/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import TextStyle
import TTTAttributedLabel

class LinkSelfPostCardView: LinkCardView {

  private static let readMoreURL = NSURL(string: "reddit://read_more")!

  override var viewModel: LinkItemViewModel? {
    didSet {
      guard let selfPostViewModel = viewModel as? LinkItemSelfPostViewModel else { return }
      label.setText(selfPostViewModel.selfText)
    }
  }

  var readMoreClicked: (() -> Void)? = nil

  // MARK: - Views
  private lazy var containerView: UIView = self.createContainerView()
  private lazy var label: TTTAttributedLabel = self.createLabel()

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
    let tapGestureRecognizer = UITapGestureRecognizer()
    tapGestureRecognizer.cancelsTouchesInView = false
    tapGestureRecognizer.delegate = self
    containerView.addGestureRecognizer(tapGestureRecognizer)
    contentView = containerView
    setupConstraints()
  }

  private func setupConstraints() {
    label.snp_makeConstraints { make in
      make.left.right.equalTo(containerView).inset(8)
      make.top.bottom.equalTo(containerView).inset(4)
    }
  }

  override func didAppear() {
    super.didAppear()
  }

  override func didDisappear() {
    super.didDisappear()
  }
}

extension LinkSelfPostCardView {

  private func createLabel() -> TTTAttributedLabel {
    let label = TTTAttributedLabel(frame: CGRect.zero)
    TextStyle.Caption1.rx_font
      .bindTo(label.rx_font)
      .addDisposableTo(self.rx_disposeBag)
    label.verticalAlignment = .Top
    label.numberOfLines = 0
    label.textAlignment = .Left
    label.delegate = self
    label.truncationLineEnabled = true
    label.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
    label.extendsLinkTouchArea = true

    Theming.sharedInstance.textColor
      .bindTo(label.rx_textColor)
      .addDisposableTo(self.rx_disposeBag)

    Theming.sharedInstance.accentColor
      .subscribeNext { accentColor in
        label.linkAttributes = [NSForegroundColorAttributeName: accentColor]
        label.activeLinkAttributes = [NSForegroundColorAttributeName:
          accentColor.colorWithAlphaComponent(0.5)]
        let attributes = [NSLinkAttributeName: LinkSelfPostCardView.readMoreURL,
          NSForegroundColorAttributeName: accentColor]
        label.attributedTruncationToken =
          NSAttributedString(string: tr(.LinkContentSelfPostReadMore), attributes: attributes)
      }.addDisposableTo(self.rx_disposeBag)

    return label
  }

  private func createContainerView() -> UIView {
    let view = UIView()
    view.addSubview(self.label)
    return view
  }

}

// MARK: - TTTAttributedLabelDelegate
extension LinkSelfPostCardView {

  override func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
    guard url != LinkSelfPostCardView.readMoreURL else {
      readMoreClicked?()
      return
    }
    super.attributedLabel(label, didSelectLinkWithURL: url)
  }
}

// MARK: - UIGestureRecognizerDelegate
extension LinkSelfPostCardView: UIGestureRecognizerDelegate {

  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    return label.gestureRecognizer(gestureRecognizer, shouldReceiveTouch: touch)
  }
}
