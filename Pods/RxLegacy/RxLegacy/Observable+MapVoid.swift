//
//  Observable+MapVoid.swift
//  Unbabel
//
//  Created by Ivan Bruel on 24/01/2017.
//  Copyright © 2017 Unbabel. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {

  /**
   Helpful function to be able to abstract observable sequences into void.
   e.g. Observable.just(something).mapVoid()
   - returns: anything is turned into void
   */
  public func mapVoid() -> Observable<Void> {
    return map { _ in Void() }
  }
}
