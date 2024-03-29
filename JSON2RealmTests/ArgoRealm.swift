//
//  ArgoRealm.swift
//  JSON2Realm
//
//  Created by Wane Wang on 2016/1/3.
//  Copyright © 2016年 Wane Wang. All rights reserved.
//

import Foundation
import Argo
import Curry
import RealmSwift

class ArgoClass: BasicClass {
    
    convenience required init(name: String, birthday: String, age: Int) {
        self.init()
        self.name = name
        self.birthday = birthday
        self.age = age
    }
}

extension ArgoClass: Decodable {
    
    static func decode(json: JSON) -> Decoded<ArgoClass> {
        return curry(ArgoClass.init)
            <^> json <| "name"
            <*> json <| "birthday"
            <*> json <| "age"
    }
}

class ArgoOptionalClass: BasicOptionalClass {
    
    convenience required init(distance: Int?, note: String?, value: Int) {
        self.init()
        self.distance.value = distance
        self.note = note
        self.value = value
    }
}

extension ArgoOptionalClass: Decodable {
    
    static func decode(json: JSON) -> Decoded<ArgoOptionalClass> {
        return curry(ArgoOptionalClass.init)
            <^> json <|? "distance"
            <*> json <|? "note"
            <*> json <| "value"
    }
}