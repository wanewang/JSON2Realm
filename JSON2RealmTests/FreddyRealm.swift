//
//  FreddyRealm.swift
//  JSON2Realm
//
//  Created by Wane Wang on 2/4/16.
//  Copyright © 2016 Wane Wang. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

class FreddyClass: BasicClass, JSONDecodable {
    convenience required init(json: JSON) throws {
        self.init()
        self.name = try json.string("name")
        self.birthday = try json.string("birthday")
        self.age = try json.int("age")
    }
}

class OptionalFreddyClass: BasicOptionalClass, JSONDecodable {
    convenience required init(json: JSON) throws {
        self.init()
        self.distance.value = try json.int("distance", ifNotFound: true)
        self.note = try json.string("note", ifNotFound: true)
        self.value = try json.int("value")
    }
}