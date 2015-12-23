//
//  BasicRealm.swift
//  JSON2Realm
//
//  Created by Wane Wang on 2015/12/23.
//  Copyright © 2015年 Wane Wang. All rights reserved.
//

import Foundation
import RealmSwift

class BasicClass: Object {
    dynamic var name: String = ""
    dynamic var birthday: String = ""
    dynamic var age: Int = 0
}

class BasicOptionalClass: Object {
    var distance = RealmOptional<Int>()
    dynamic var note: String? = nil
    dynamic var value: Int = 0
}