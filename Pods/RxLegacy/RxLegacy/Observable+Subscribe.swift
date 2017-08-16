//
//  Observable+Subscribe.swift
//  Unbabel
//
//  Created by Ivan Bruel on 17/02/2017.
//  Copyright © 2017 Unbabel. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {

  public func subscribeNext(_ onNext: @escaping (E) -> Void) -> Disposable {
    return subscribe(onNext: onNext)
  }

  public func subscribeError(_ onError: @escaping (Error) -> Void) -> Disposable {
    return subscribe(onError: onError)
  }

  public func subscribeCompleted(_ onCompleted: @escaping () -> Void) -> Disposable {
    return subscribe(onCompleted: onCompleted)
  }

  public func subscribeDisposed(_ onDisposed: @escaping () -> Void) -> Disposable {
    return subscribe(onDisposed: onDisposed)
  }

}
