//
//  UserMeSpec.swift
//  SwipeIt
//
//  Created by Ivan Bruel on 16/08/2017.
//  Copyright © 2017 Faber Ventures. All rights reserved.
//

import Quick
import Nimble
import Moya_ObjectMapper
import NSObject_Rx
import ObjectMapper

class UserMeSpec: QuickSpec {

  override func spec() {
    describe("A User") {
      var user: User!
      describe("can be deserialized") {
        user = JSONReader.readFromJSON("UserMe")

        it("exists") {
          expect(user).toNot(beNil())
        }

      }
    }
  }
}
