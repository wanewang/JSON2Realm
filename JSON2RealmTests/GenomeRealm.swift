//
//  GenomeRealm.swift
//  JSON2Realm
//
//  Created by Wane Wang on 2015/12/22.
//  Copyright © 2015年 Wane Wang. All rights reserved.
//

import Foundation
import Genome
import PureJsonSerializer
import RealmSwift

extension NSNull: JsonConvertibleType {
    public static func newInstance(json: Json, context: Context) throws -> Self {
        return self.init()
    }
    public func jsonRepresentation() throws -> Json {
        return .NullValue
    }
}

final class GenomeClass: BasicClass, MappableObject {
    
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

final class OptionalGenomeClass: BasicOptionalClass, MappableObject {
    
    convenience required init(map: Map) throws {
        self.init()
        try self.note = <~map["note"]
        try self.distance.value = <~map["distance"]
        try self.value = <~map["value"]
    }
    
    func sequence(map: Map) throws {
        try self.note ~> map["note"]
            .transformToJson { (value: String?) -> Json in
                if let text = value {
                    return Json(text)
                }
                return Json.NullValue
            }
        try self.distance.value ~> map["distance"]
        
    }
}

