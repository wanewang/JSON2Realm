//
//  UnboxRealm.swift
//  JSON2Realm
//
//  Created by Wane Wang on 2016/1/6.
//  Copyright © 2016年 Wane Wang. All rights reserved.
//

import Foundation
import Unbox

class UnboxClass: BasicClass, Unboxable {
    
    convenience required init(unboxer: Unboxer) {
        self.init()
        self.name = unboxer.unbox("name")
        self.birthday = unboxer.unbox("birthday")
        self.age = unboxer.unbox("age")
    }
}

class UnboxOptionalClass: BasicOptionalClass, Unboxable {
    convenience required init(unboxer: Unboxer) {
        self.init()
        self.value = unboxer.unbox("value")
        self.note = unboxer.unbox("note")
        self.distance.value = unboxer.unbox("distance")
    }
}
