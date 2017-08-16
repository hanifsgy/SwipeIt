//
//  Observable+ResultSubscribe.swift
//  Unbabel
//
//  Created by Ivan Bruel on 17/02/2017.
//  Copyright © 2017 Unbabel. All rights reserved.
//

import Foundation
import RxSwift
import Result
import RxResult

public extension ObservableType where E: ResultProtocol {

  public func subscribeSuccess(_ onSuccess: @escaping (Self.E.Value) -> Void) -> Disposable {
    return subscribeResult(onSuccess: onSuccess)
  }

  public func subscribeFailure(_ onFailure: @escaping (Self.E.Error) -> Void) -> Disposable {
    return subscribeResult(onFailure: onFailure)
  }
}
