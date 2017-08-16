//
//  CloseableViewController.swift
//  Reddit
//
//  Created by Ivan Bruel on 26/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import NSObject_Rx

protocol CloseableViewController {

  func setupCloseButton()

}

extension CloseableViewController where Self: UIViewController {

  func setupCloseButton() {
    guard let firstViewController = navigationController?.viewControllers.first, firstViewController == self else {
        return
    }

    let closeButton = UIBarButtonItem(title: L10n.Closeable.Button.close, style: .plain, target: nil,
                                      action: nil)
    closeButton.rx.tap
      .bindNext { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
      }.addDisposableTo(rx_disposeBag)
    navigationItem.leftBarButtonItem = closeButton
  }
}
