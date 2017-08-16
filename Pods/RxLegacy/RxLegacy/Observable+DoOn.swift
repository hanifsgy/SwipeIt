//
//  Observable+DoOn.swift
//  Unbabel
//
//  Created by Ivan Bruel on 16/02/2017.
//  Copyright © 2017 Unbabel. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {

  public func doOnNext(_ onNext: @escaping (E) throws -> Void) -> Observable<E> {
    return `do`(onNext: onNext)
  }

  public func doOnError(_ onError: @escaping (Error) throws -> Void) -> Observable<E> {
    return `do`(onError: onError)
  }

  public func doOnCompleted(_ onCompleted: @escaping () throws -> Void) -> Observable<E> {
    return `do`(onCompleted: onCompleted)
  }

  public func doOnDispose(_ onDispose: @escaping () -> Void) -> Observable<E> {
    return `do`(onDispose: onDispose)
  }

  public func doOnSubscribe(_ onSubscribe: @escaping () -> Void) -> Observable<E> {
    return `do`(onSubscribe: onSubscribe)
  }

}
