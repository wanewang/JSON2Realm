//
//  GenomeRealm.swift
//  JSON2Realm
//
//  Created by Wane Wang on 2015/12/22.
//  Copyright © 2015年 Wane Wang. All rights reserved.
//

import Foundation
import Genome
import RealmSwift

class GenomeClass: BasicClass, StandardMappable {
    
    // checkout document:
    // https://realm.io/docs/swift/latest/#adding-custom-initializers-to-object-subclasses
    convenience required init(map: Map) throws {
        self.init()
        try self.name = <~map["name"]
        try self.birthday = <~map["birthday"]
        try self.age = <~map["age"]
    }
    
    func sequence(map: Map) throws {
        try self.name ~> map["name"]
        try self.birthday ~> map["birthday"]
        try self.age ~> map["age"]
    }
    
}

class OptionalGenomeClass: BasicOptionalClass, StandardMappable {
    
    convenience required init(map: Map) throws {
        self.init()
        try self.note = <~?map["note"]
        try self.distance.value = <~?map["distance"]
        try self.value = <~map["value"]
    }
    
    func sequence(map: Map) throws {
        try self.note ~> map["note"]
        try self.distance.value ~> map["distance"]
            .transformToJson {
                $0 ?? NSNull()
        }
    }
}

