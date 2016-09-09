//
//  ShareableViewController.swift
//  SwipeIt
//
//  Created by Ivan Bruel on 09/09/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

protocol ShareableViewController {

  func share(text: String?, URL: NSURL?, image: UIImage?, fromView: UIView?)

}

extension ShareableViewController where Self: UIViewController {

  func share(text: String? = nil, URL: NSURL? = nil, image: UIImage? = nil,
             fromView: UIView? = nil) {
    let shareables: [AnyObject?] = [text, URL, image]

    let activityViewController = UIActivityViewController(activityItems: shareables.flatMap { $0 },
                                                          applicationActivities: nil)

    activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop,
                                                    UIActivityTypeOpenInIBooks]

    activityViewController.popoverPresentationController?.sourceView = fromView
    self.presentViewController(activityViewController, animated: true, completion: nil)
  }
}
