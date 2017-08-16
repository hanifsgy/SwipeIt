//
//  VoteOverlayView.swift
//  SwipeIt
//
//  Created by Ivan Bruel on 07/09/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import TextStyle

class VoteOverlayView: UIView {

  fileprivate lazy var blurView: UIVisualEffectView = self.createBlurView()
  fileprivate lazy var label: UILabel = self.createLabel()

  override var tintColor: UIColor! {
    didSet {
      label.textColor = tintColor
      borderColor = tintColor
    }
  }

  var text: String? {
    get {
      return label.text
    }
    set {
      label.text = newValue
    }
  }

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

  func commonInit() {
    cornerRadius = 4
    clipsToBounds = true
    borderColor = tintColor
    borderWidth = 3

    addSubview(blurView)

    blurView.snp_makeConstraints { make in
      make.edges.equalTo(self)
    }

    label.snp_makeConstraints { make in
      make.top.bottom.equalTo(self).inset(8)
      make.left.right.equalTo(self).inset(16)
    }
  }
}

extension VoteOverlayView {

  fileprivate func createBlurView() -> UIVisualEffectView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    view.addSubview(label)
    return view
  }

  fileprivate func createLabel() -> UILabel {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = tintColor
    label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
    label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
    TextStyle.headline.rx_font
      .bindTo(label.rx.font)
      .addDisposableTo(rx_disposeBag)
    return label
  }
}
