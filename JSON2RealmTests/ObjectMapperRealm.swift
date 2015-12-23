//
//  ObjectMapperRealm.swift
//  JSON2Realm
//
//  Created by Wane Wang on 2015/12/23.
//  Copyright © 2015年 Wane Wang. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class ObjectMapperClass: BasicClass, Mappable {
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.name <- map["name"]
        self.birthday <- map["birthday"]
        self.age <- map["age"]
    }
}

class ObjectMapperOptionalClass: BasicOptionalClass, Mappable {
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.note <- map["note"]
        self.distance.value <- map["distance"]
        self.value <- map["value"]
    }
}