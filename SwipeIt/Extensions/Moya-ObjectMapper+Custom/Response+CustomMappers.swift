//
//  Response+CustomMappers.swift
//  Reddit
//
//  Created by Ivan Bruel on 28/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import RxSwift

extension Response {

  func mapPair<T: Mappable, U: Mappable>() throws -> (T, U) {
    guard let jsonArray = try mapJSON() as? [[String: Any]], jsonArray.count == 2 else {
      throw MoyaError.jsonMapping(self)
    }
    guard let firstObject = Mapper<T>().map(JSON: jsonArray[0]),
      let secondObject = Mapper<U>().map(JSON: jsonArray[1]) else {
        throw MoyaError.jsonMapping(self)
    }
    return (firstObject, secondObject)
  }

  /**
   Adds a transformation over the initial JSON. Specially useful to reformat wrongfully formatted
   JSON.

   - parameter type: The Type for the ObjectMapper.
   - parameter jsonTransform: Transformation block for the JSON object.

   - throws: Can throw a JSONMapping Error

   - returns: The transformed JSON object.
   */
  func mapObject<T: Mappable>(_ type: T.Type, jsonTransform: (Any?) -> Any?) throws -> T {
    guard let json = try jsonTransform(mapJSON()) as? [String: Any] else {
       throw MoyaError.jsonMapping(self)
    }
    guard let object = Mapper<T>().map(JSON: json) else {
      throw MoyaError.jsonMapping(self)
    }
    return object
  }

}

extension ObservableType where E == Response {

  func mapPair<T: Mappable, U: Mappable>(_ type1: T.Type, _ type2: U.Type) -> Observable<(T, U)> {
    return flatMap { response -> Observable<(T, U)> in
      return Observable.just(try response.mapPair())
    }
  }

  /**
   Adds a transformation over the initial JSON. Specially useful to reformat wrongfully formatted
   JSON.

   - parameter type: The Type for the ObjectMapper.
   - parameter jsonTransform: Transformation block for the JSON object.

   - returns: The transformed JSON Object observable.
   */
  func mapObject<T: Mappable>(_ type: T.Type, jsonTransform: @escaping (Any?) -> Any?)
    -> Observable<T> {
    return flatMap { response -> Observable<T> in
      return Observable.just(try response.mapObject(type, jsonTransform: jsonTransform))
    }
  }
}
