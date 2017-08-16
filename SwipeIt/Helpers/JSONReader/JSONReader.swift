//
//  JSONReader.swift
//  Reddit
//
//  Created by Ivan Bruel on 02/03/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

class JSONReader {

  class func readFromJSON<T: Mappable>(_ filename: String) -> T? {
    guard let jsonString = JSONReader.readJSONString(filename) else {
      return nil
    }
    return Mapper<T>().map(JSONString: jsonString)
  }

  class func readJSONString(_ filename: String) -> String? {
    return String(data: readJSONData(filename), encoding: String.Encoding.utf8)
  }

  class func readJSONData(_ filename: String) -> Data {
    return FileReader.readFileData(filename, fileExtension: "json")
  }

}
