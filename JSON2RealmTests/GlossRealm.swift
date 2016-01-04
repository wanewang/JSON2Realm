//
//  GlossRealm.swift
//  JSON2Realm
//
//  Created by Wane Wang on 2016/1/4.
//  Copyright © 2016年 Wane Wang. All rights reserved.
//

import Foundation
import Gloss
import RealmSwift

final class GlossClass: BasicClass, Glossy {
    convenience required init?(json: JSON) {
        self.init()
        guard let name: String = "name" <~~ json,
            let birthday: String = "birthday" <~~ json,
            let age: Int = "age" <~~ json
            else { return nil }
        self.name = name
        self.birthday = birthday
        self.age = age
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "name" ~~> self.name,
            "birthday" ~~> self.birthday,
            "age" ~~> self.age
        ])
    }
}

final class GlossOptionalClass: BasicOptionalClass, Glossy {
    convenience required init?(json: JSON) {
        self.init()
        guard let value: Int = "value" <~~ json
            else { return nil }
        self.value = value
        self.note = "note" <~~ json
        self.distance.value = "distance" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "value" ~~> self.value,
            Encoder.encodeStringNull("note")(self.note),
            "distance" ~~> self.distance.value
        ])
    }
}

extension Encoder {
    static func encodeStringNull(key: String) -> String? -> JSON {
        return {
            string in
            if let string = string {
                return [key : string]
            }
            return [key : NSNull()]
        }
    }
}