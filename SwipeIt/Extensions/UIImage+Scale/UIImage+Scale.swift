//
//  UIImage+Scale.swift
//  SwipeIt
//
//  Created by Ivan Bruel on 25/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImage {

  func scaleToSizeWithAspectFill(_ size: CGSize) -> UIImage {
    let ratio = self.size.ratio
    let maxSize = max(size.width, size.height)
    let width = ratio > 1 ? maxSize * ratio : maxSize
    let height = ratio > 1 ? maxSize : maxSize * ratio
    return scaleToSizeWithAspectFit(CGSize(width: width, height: height))
  }

  func scaleToSizeWithAspectFit(_ size: CGSize) -> UIImage {
    let scaledRect = AVMakeRect(aspectRatio: self.size,
                                                         insideRect: CGRect(origin: .zero, size: size))
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    draw(in: scaledRect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
}
