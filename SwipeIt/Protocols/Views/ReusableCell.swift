//
//  ReusableCell.swift
//  Reddit
//
//  Created by Ivan Bruel on 04/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

// This protocol assume your cell's identifier is the actual class name for the custom cell
// You can customize the reuseIdentifier by implementing the reuseIdentifier property.
protocol ReusableCell {

  var reuseIdentifier: String? { get }

}

extension ReusableCell where Self: UICollectionViewCell {

  var reuseIdentifier: String? {
    return Self.className
  }

}

extension ReusableCell where Self: UITableViewCell {

  var reuseIdentifier: String? {
    return Self.className
  }

}

extension UICollectionView {

  func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, index: Int) -> T {
    return dequeueReusableCell(type, indexPath: IndexPath(item: index, section: 0))
  }

  func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
    return self.dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as? T ?? T()
  }

}

extension UITableView {

  func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, index: Int) -> T {
    return dequeueReusableCell(type, indexPath: IndexPath(row: index, section: 0))
  }

  func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
    return self.dequeueReusableCell(withIdentifier: T.className, for: indexPath) as? T ?? T()
  }

}
