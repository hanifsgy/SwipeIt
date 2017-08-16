//
//  LinkCardView.swift
//  Reddit
//
//  Created by Ivan Bruel on 19/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import RxColor
import RxSwift
import TextStyle
import TTTAttributedLabel

class LinkCardView: UIView {

  // MARK: - Constants
  fileprivate static let spacing: CGFloat = 10

  // MARK: - ViewModel
  var viewModel: LinkItemViewModel? {
    didSet {
      guard let viewModel = viewModel else { return }
      animateOverlayPercentage(0)
      titleLabel.text = viewModel.title

      Observable
        .combineLatest(viewModel.context, TextStyle.caption1.rx_font,
        Theming.sharedInstance.secondaryTextColor) { ($0, $1, $2) }
        .subscribeNext { [weak self] (context, font, textColor) in
          guard let context = context else {
            self?.contextLabel.setText(nil)
            return
          }
          let mutableContext = NSMutableAttributedString(attributedString: context)
          mutableContext.setFont(font)
          mutableContext.setTextColor(textColor)
          self?.contextLabel.setText(mutableContext)
        }.addDisposableTo(rx_disposeBag)

      LinkCardView
        .statsAttributedString(viewModel.scoreIcon, text: viewModel.score,
          font: TextStyle.caption1.rx_font)
        .bindTo(scoreLabel.rx.attributedText)
        .addDisposableTo(rx_disposeBag)

      LinkCardView
        .statsAttributedString(viewModel.commentsIcon, text: viewModel.comments,
          font: TextStyle.caption1.rx_font)
        .bindTo(commentsLabel.rx.attributedText)
        .addDisposableTo(rx_disposeBag)
    }
  }

  // MARK: - Views
  fileprivate lazy var containerView: UIView = self.createContentView()
  fileprivate lazy var titleLabel: UILabel = self.createTitleLabel()
  fileprivate lazy var contextLabel: TTTAttributedLabel = self.createContextLabel()
  fileprivate lazy var topBar: UIVisualEffectView = self.createTopBar()
  fileprivate lazy var bottomBar: UIVisualEffectView = self.createBottomBar()
  fileprivate lazy var commentsLabel: UILabel = self.createStatsLabel()
  fileprivate lazy var scoreLabel: UILabel = self.createScoreLabel()
  fileprivate lazy var upvoteOverlayImageView: VoteOverlayView = self.createUpvoteOverlayView()
  fileprivate lazy var downvoteOverlayImageView: VoteOverlayView = self.createDownvoteOverlayView()
  lazy var moreButton: UIButton = self.createMoreButton()

  var contentView: UIView? = nil {
    didSet {
      guard let contentView = contentView else { return }
      containerView.addSubview(contentView)
      contentView.snp_makeConstraints { make in
        make.top.equalTo(contextLabel.snp_bottom).offset(LinkCardView.spacing)
        make.bottom.equalTo(bottomBar.snp_top)
        make.left.right.equalTo(containerView)
      }
      containerView.bringSubview(toFront: upvoteOverlayImageView)
      containerView.bringSubview(toFront: downvoteOverlayImageView)
      containerView.bringSubview(toFront: bottomBar)
    }
    willSet {
      contentView?.removeFromSuperview()
    }
  }

  var moreOptionsClicked: ((LinkCardView) -> Void)? = nil

  // MARK: - Initializers
  init() {
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

  fileprivate func commonInit() {
    backgroundColor = .white
    borderColor = UIColor(named: .gray)
    borderWidth = 1
    cornerRadius = 4
    clipsToBounds = true
    isOpaque = true

    addSubview(containerView)
    setupConstraints()
  }

  fileprivate func setupConstraints() {
    containerView.snp_makeConstraints { make in
      make.top.left.equalTo(self)
      make.width.equalTo(bounds.width)
      make.height.equalTo(bounds.height)
    }

    topBar.snp_makeConstraints { make in
      make.top.left.right.equalTo(containerView)
    }

    titleLabel.snp_makeConstraints { make in
      make.top.left.equalTo(topBar).offset(LinkCardView.spacing)
      make.right.equalTo(topBar).inset(LinkCardView.spacing)
    }

    contextLabel.snp_makeConstraints { make in
      make.top.equalTo(titleLabel.snp_bottom).offset(LinkCardView.spacing)
      make.left.equalTo(bottomBar).offset(LinkCardView.spacing)
      make.right.equalTo(bottomBar).inset(LinkCardView.spacing)
      make.bottom.equalTo(topBar).inset(LinkCardView.spacing)
    }

    bottomBar.snp_makeConstraints { make in
      make.bottom.left.right.equalTo(containerView)
      make.height.equalTo(44)
    }

    moreButton.snp_makeConstraints { make in
      make.bottom.equalTo(bottomBar).offset(-LinkCardView.spacing)
      make.right.equalTo(bottomBar).inset(LinkCardView.spacing)
      make.top.equalTo(bottomBar).offset(LinkCardView.spacing)
      make.width.equalTo(moreButton.snp_height)
    }

    commentsLabel.snp_makeConstraints { make in
      make.bottom.equalTo(bottomBar).offset(-LinkCardView.spacing)
      make.top.left.equalTo(bottomBar).offset(LinkCardView.spacing)
    }

    scoreLabel.snp_makeConstraints { make in
      make.bottom.equalTo(bottomBar).offset(-LinkCardView.spacing)
      make.right.equalTo(moreButton.snp_left).offset(-LinkCardView.spacing)
      make.top.equalTo(bottomBar).offset(LinkCardView.spacing)
      make.left.equalTo(commentsLabel.snp_right).offset(LinkCardView.spacing)
    }

    upvoteOverlayImageView.snp_makeConstraints { make in
      make.top.equalTo(topBar.snp_bottom).offset(LinkCardView.spacing * 3)
      make.left.equalTo(containerView).offset(LinkCardView.spacing)
    }

    downvoteOverlayImageView.snp_makeConstraints { make in
      make.top.equalTo(topBar.snp_bottom).offset(LinkCardView.spacing * 3)
      make.right.equalTo(containerView).offset(-LinkCardView.spacing)
    }

    [titleLabel, contextLabel, commentsLabel, scoreLabel]
      .forEach { $0.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical) }

    [commentsLabel, scoreLabel].forEach {
      $0.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
    }
  }
}

// MARK: - API
extension LinkCardView {

  var title: String? {
    get {
      return titleLabel.text
    }
    set {
      titleLabel.text = newValue
    }
  }

  var contextText: String? {
    get {
      return contextLabel.text
    }
    set {
      contextLabel.text = newValue
    }
  }

  var commentsText: String? {
    get {
      return commentsLabel.text
    }
    set {
      commentsLabel.text = newValue
    }
  }

  var scoreText: String? {
    get {
      return scoreLabel.text
    }
    set {
      scoreLabel.text = newValue
    }
  }

  // MARK: Lifecycle
  func didAppear() {
    animateOverlayPercentage(0)
  }

  func didDisappear() {
    animateOverlayPercentage(0)
  }

  // MARK: Animation
  func animateOverlayPercentage(_ percentage: CGFloat) {
    let upvoteAlpha = max(min(percentage, 1), 0)
    let downvoteAlpha = max(min(-percentage, 1), 0)

    if upvoteAlpha != upvoteOverlayImageView.alpha {
      upvoteOverlayImageView.alpha = upvoteAlpha
    }

    if downvoteAlpha != downvoteOverlayImageView.alpha {
      downvoteOverlayImageView.alpha = downvoteAlpha
    }
  }
}

// MARK: - View Builders
extension LinkCardView {

  fileprivate func createContextLabel() -> TTTAttributedLabel {
    let label = TTTAttributedLabel(frame: CGRect.zero)
    label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
    label.numberOfLines = 1
    label.textAlignment = .left
    label.delegate = self

    Theming.sharedInstance.secondaryTextColor
      .bindTo(label.rx.textColor)
      .addDisposableTo(self.rx_disposeBag)

    Theming.sharedInstance.accentColor
      .subscribeNext { accentColor in
        label.linkAttributes = [NSForegroundColorAttributeName: accentColor]
        label.activeLinkAttributes = [NSForegroundColorAttributeName:
          accentColor.withAlphaComponent(0.5)]
      }.addDisposableTo(self.rx_disposeBag)

    return label
  }

  fileprivate func createUpvoteOverlayView() -> VoteOverlayView {
    let view = VoteOverlayView()
    view.text = L10n.Link.upvote.uppercased()
    view.tintColor = UIColor(named: .orange)
    view.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi)/6)
    return view
  }

  fileprivate func createDownvoteOverlayView() -> VoteOverlayView {
    let view = VoteOverlayView()
    view.text = L10n.Link.downvote.uppercased()
    view.tintColor = UIColor(named: .purple)
    view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi)/6)
    return view
  }

  fileprivate func createTitleLabel() -> UILabel {
    let label = UILabel()
    label.numberOfLines = 0
    label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)

    TextStyle.subheadline.rx_font
      .bindTo(label.rx.font)
      .addDisposableTo(self.rx_disposeBag)

    Theming.sharedInstance.textColor
      .bindTo(label.rx.textColor)
      .addDisposableTo(self.rx_disposeBag)
    return label
  }

  fileprivate func createStatsLabel() -> UILabel {
    let label = UILabel(frame: CGRect.zero)
    TextStyle.caption1.rx_font
      .bindTo(label.rx.font)
      .addDisposableTo(self.rx_disposeBag)
    label.textAlignment = .right

    Theming.sharedInstance.secondaryTextColor
      .bindTo(label.rx.textColor)
      .addDisposableTo(self.rx_disposeBag)

    return label
  }

  fileprivate func createScoreLabel() -> UILabel {
    let label = createStatsLabel()
    label.textAlignment = .right
    return label
  }

  fileprivate func createMoreButton() -> UIButton {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(asset: .MoreIcon), for: UIControlState())
    Theming.sharedInstance.accentColor
      .subscribeNext { color in
        button.setImage(UIImage(asset: .MoreIcon).tint(color), for: .highlighted)
      }.addDisposableTo(self.rx_disposeBag)
    button.rx.tap.subscribeNext { [weak self] _ in
      guard let `self` = self else { return }
      self.moreOptionsClicked?(self)
    }.addDisposableTo(self.rx_disposeBag)
    return button
  }

  fileprivate func createBottomBar() -> UIVisualEffectView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    view.addSubview(self.commentsLabel)
    view.addSubview(self.scoreLabel)
    view.addSubview(self.moreButton)
    return view
  }

  fileprivate func createTopBar() -> UIVisualEffectView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    view.addSubview(self.titleLabel)
    view.addSubview(self.contextLabel)
    return view
  }

  fileprivate func createContentView() -> UIView {
    let view = UIView()
    view.addSubview(self.bottomBar)
    view.addSubview(self.topBar)
    view.addSubview(self.upvoteOverlayImageView)
    view.addSubview(self.downvoteOverlayImageView)
    return view
  }
}

// MARK: - Helpers
extension LinkCardView {

  fileprivate static func statsAttributedString(_ icon: Observable<UIImage>,
                                            text: Observable<NSAttributedString>,
                                            font: Observable<UIFont>)
    -> Observable<NSAttributedString?> {

      let icon = iconAttributedString(icon, font: font)

      return Observable.combineLatest(icon, text) {
        [$0, $1].joined(separator: " ")
      }
  }

  fileprivate static func iconAttributedString(_ icon: Observable<UIImage>, font: Observable<UIFont>)
    -> Observable<NSAttributedString> {
      return Observable.combineLatest(icon, font) { (icon, font) -> NSAttributedString in
        let attachment = ImageAttachment(icon, verticalOffset: font.descender)
        return NSAttributedString(attachment: attachment)
      }
  }
}

extension LinkCardView: TTTAttributedLabelDelegate {

}
