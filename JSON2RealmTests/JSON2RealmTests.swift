//
//  JSON2RealmTests.swift
//  JSON2RealmTests
//
//  Created by Wane Wang on 2015/12/22.
//  Copyright © 2015年 Wane Wang. All rights reserved.
//

import XCTest
@testable import JSON2Realm
import Genome
import ObjectMapper
import Gloss
import Argo
import Unbox
import Freddy
import RealmSwift
import PureJsonSerializer

class JSON2RealmTests: XCTestCase {
    var realm: Realm!
    var basicDict1: [String: AnyObject]!
    var basicDict2: [String: AnyObject]!
    var basicOptionalDict1: [String: AnyObject]!
    var basicOptionalDict2: [String: AnyObject]!
    var basicOptionalDict3: [String: AnyObject]!
    override func setUp() {
        super.setUp()
        
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        self.realm = try! Realm()
        
        self.basicDict1 = [
            "name": "abc",
            "birthday": "1988-02-03",
            "age": 13
        ]
        self.basicDict2 = [
            "name": "abcdef",
            "birthday": "1988-01-02",
            "age": 50
        ]
        self.basicOptionalDict1 = [
            "note": "abc",
            "value": 3
        ]
        self.basicOptionalDict2 = [
            "distance": 13,
            "value": 4
        ]
        self.basicOptionalDict3 = [
            "note": "def"
        ]
        
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGenomeClass() {
        do {
            let json1: Json = Json.from(self.basicDict1)
            let json2 = Json.from(self.basicDict2)
            let mappedBasic1 = try GenomeClass.init(js: json1)
            let mappedBasic2 = try GenomeClass.newInstance(json2)
            let emptyBadic = GenomeClass.init()
            try self.realm.write { () -> Void in
                self.realm.add(mappedBasic1)
                self.realm.add(mappedBasic2)
                self.realm.add(emptyBadic)
            }
        } catch is MappingError {
            XCTFail("mapped object error")
        } catch {
            XCTFail("realm save object error")
        }
        let results = self.realm.objects(GenomeClass)
        let test = Array(results)
        XCTAssert(test.count == 3)
        if let last = test.last {
            XCTAssert(last.name == "", "last object should be empty with default value")
        } else {
            XCTFail("last should not be nil")
        }
        if let first = test.first {
            XCTAssert(first.birthday != "", "first object birthday should not be default value")
        } else {
            XCTFail("last should not be nil")
        }
    }
    
    func testGenomeOptionalClass() {
        do {
            let jsonOption1: Json = Json.from(self.basicOptionalDict1)
            let jsonOption2 = Json.from(self.basicOptionalDict2)
            let mappedBasic1 = try OptionalGenomeClass.init(js: jsonOption1)
            let mappedBasic2 = try OptionalGenomeClass.newInstance(jsonOption2)
            let emptyBadic = OptionalGenomeClass.init()
            try self.realm.write { () -> Void in
                self.realm.add(mappedBasic1)
                self.realm.add(mappedBasic2)
                self.realm.add(emptyBadic)
            }
            
            // test toJSON
            let json1 = try mappedBasic1.jsonRepresentation()
            if let note = json1["note"] {
                    XCTAssert(!(note.isNull), "custom encode non-nil value should not be NSNull")
            } else {
                XCTFail("OptionalGenomeClass jsonRepresentation should success")
            }
            let json2 = try mappedBasic2.jsonRepresentation()
            if let note = json2["note"] {
                    XCTAssert(note.isNull, "custom encode nil value should be parsed as NSNull")
            } else {
                XCTFail("OptionalGenomeClass jsonRepresentation should success")
            }
            
            // ******
            // since Genome return Json Object, you have to use .foundationDictionary or .anyValue to get Dictionary or AnyObject
            if let dict1 = json1.foundationDictionary,
                let note = dict1["note"] {
                XCTAssert(!(note is NSNull), "custom encode non-nil value should not be NSNull")
            } else {
                XCTFail("OptionalGenomeClass jsonRepresentation should success")
            }
            if let dict2 = json2.foundationDictionary,
                let note = dict2["note"] {
                XCTAssert(note is NSNull, "custom encode nil value should be parsed as NSNull")
            } else {
                XCTFail("OptionalGenomeClass jsonRepresentation should success")
            }
        } catch is MappingError {
            XCTFail("mapped object error")
        } catch {
            XCTFail("realm save object error")
        }
        
        do {
            let jsonOption3 = Json.from(self.basicOptionalDict3)
            let _ = try OptionalGenomeClass.newInstance(jsonOption3)
            XCTFail("parse nil value to nonoptional attribute should throw error")
        } catch {
            // Genome will throw error if marked non-optional whose json is nil
        }
        
        let results = self.realm.objects(OptionalGenomeClass)
        let test = Array(results)
        XCTAssert(test.count == 3)
        if let last = test.last {
            XCTAssert(last.note == nil, "last object should be empty with all value nil")
        } else {
            XCTFail("last should not be nil")
        }
        if let first = test.first {
            XCTAssert(first.note != nil, "first object note should not be nil")
        } else {
            XCTFail("last should not be nil")
        }
        
    }
    
    func testObjectMapperClass() {
        let emptyBadic = ObjectMapperClass.init()
        guard let mappedBasic1 = Mapper<ObjectMapperClass>().map(self.basicDict1),
            let mappedBasic2 = Mapper<ObjectMapperClass>().map(self.basicDict2) else {
                XCTFail("parse object failed")
                return
        }
        
        do {
            try self.realm.write { () -> Void in
                self.realm.add(mappedBasic1)
                self.realm.add(mappedBasic2)
                self.realm.add(emptyBadic)
            }
        } catch {
            XCTFail("realm save object error")
        }
        let results = self.realm.objects(ObjectMapperClass)
        let test = Array(results)
        XCTAssert(test.count == 3)
        if let last = test.last {
            XCTAssert(last.name == "", "last object should be empty with default value")
        } else {
            XCTFail("last should not be nil")
        }
        if let first = test.first {
            XCTAssert(first.birthday != "", "first object birthday should not be default value")
        } else {
            XCTFail("last should not be nil")
        }
    }
    
    func testObjectMapperOptionalClass() {
        let emptyBadic = ObjectMapperOptionalClass.init()
        guard let mappedBasic1 = Mapper<ObjectMapperOptionalClass>().map(self.basicOptionalDict1),
            let mappedBasic2 = Mapper<ObjectMapperOptionalClass>().map(self.basicOptionalDict2) else {
                XCTFail("parse object failed")
                return
        }
        do {
            try self.realm.write { () -> Void in
                self.realm.add(mappedBasic1)
                self.realm.add(mappedBasic2)
                self.realm.add(emptyBadic)
            }
        } catch {
            XCTFail("realm save object error")
        }
        
        // ObjectMapper will set to default value if marked non-optional whose json is nil
        if let mappedBasic3 = Mapper<ObjectMapperOptionalClass>().map(self.basicOptionalDict3) {
            XCTAssert(mappedBasic3.distance.value == nil, "parse nil value to nonoptional attribute should be nil")
            XCTAssert(mappedBasic3.value == 0, "json don't have value key, it should be set as default")
        }
        
        let results = self.realm.objects(ObjectMapperOptionalClass)
        let test = Array(results)
        XCTAssert(test.count == 3)
        if let last = test.last {
            XCTAssert(last.note == nil, "last object should be empty with all value nil")
        } else {
            XCTFail("last should not be nil")
        }
        if let first = test.first {
            XCTAssert(first.note != nil, "first object note should not be nil")
        } else {
            XCTFail("last should not be nil")
        }
        
        // test toJSON
        // need to execute inside realm write transaction
        try! self.realm.write { () -> Void in
            let json1 = Mapper().toJSON(mappedBasic1)
            let json2 = Mapper().toJSON(mappedBasic2)
            if let note = json1["note"] {
                XCTAssert(!(note is NSNull), "custom encode non-nil value should not be NSNull")
            } else {
                XCTFail("ObjectMapperOptionalClass toJSON should success")
            }
            if let _ = json2["note"] {
                XCTFail("default nil value should be parsed as nil value")
            }
            // ObjectMapperOptionalClass should have custom transformer for String
        }
        
    }
    
    func testArgoClass() {
        
        let emptyBadic = ArgoClass.init()
        guard let mappedBasic1: ArgoClass = decode(self.basicDict1),
            let mappedBasic2: ArgoClass = decode(self.basicDict2) else {
                XCTFail("parse object failed")
                return
        }
        
        do {
            try self.realm.write { () -> Void in
                self.realm.add(mappedBasic1)
                self.realm.add(mappedBasic2)
                self.realm.add(emptyBadic)
            }
        } catch {
            XCTFail("realm save object error")
        }
        
        let results = self.realm.objects(ArgoClass)
        let test = Array(results)
        XCTAssert(test.count == 3)
        if let last = test.last {
            XCTAssert(last.name == "", "last object should be empty with default value")
        } else {
            XCTFail("last should not be nil")
        }
        if let first = test.first {
            XCTAssert(first.birthday != "", "first object birthday should not be default value")
        } else {
            XCTFail("last should not be nil")
        }
    }
    
    func testArgoOptionalClass() {
        let emptyBadic = ArgoOptionalClass.init()
        guard let mappedBasic1: ArgoOptionalClass = decode(self.basicOptionalDict1),
            let mappedBasic2: ArgoOptionalClass = decode(self.basicOptionalDict2) else {
                XCTFail("parse object failed")
                return
        }
        do {
            try self.realm.write { () -> Void in
                self.realm.add(mappedBasic1)
                self.realm.add(mappedBasic2)
                self.realm.add(emptyBadic)
            }
        } catch {
            XCTFail("realm save object error")
        }
        
        // Argo will return nil object if marked non-optional whose json is nil
        if let _: ArgoOptionalClass = decode(self.basicOptionalDict3) {
            XCTFail("Argo will return nil object if marked non-optional whose json is nil")
        }
        
        let results = self.realm.objects(ArgoOptionalClass)
        let test = Array(results)
        XCTAssert(test.count == 3)
        if let last = test.last {
            XCTAssert(last.note == nil, "last object should be empty with all value nil")
        } else {
            XCTFail("last should not be nil")
        }
        if let first = test.first {
            XCTAssert(first.note != nil, "first object note should not be nil")
        } else {
            XCTFail("last should not be nil")
        }
    }
    
    func testGlossClass() {
        let emptyBadic = GlossClass.init()
        guard let mappedBasic1 = GlossClass(json: self.basicDict1),
            let mappedBasic2 = GlossClass(json: self.basicDict2) else {
                XCTFail("parse object failed")
                return
        }
        
        do {
            try self.realm.write { () -> Void in
                self.realm.add(mappedBasic1)
                self.realm.add(mappedBasic2)
                self.realm.add(emptyBadic)
            }
        } catch {
            XCTFail("realm save object error")
        }
        
        let results = self.realm.objects(GlossClass)
        let test = Array(results)
        XCTAssert(test.count == 3)
        if let last = test.last {
            XCTAssert(last.name == "", "last object should be empty with default value")
        } else {
            XCTFail("last should not be nil")
        }
        if let first = test.first {
            XCTAssert(first.birthday != "", "first object birthday should not be default value")
        } else {
            XCTFail("last should not be nil")
        }
    }
    
    func testGlossOptionalClass() {
        let emptyBadic = GlossOptionalClass.init()
        guard let mappedBasic1 = GlossOptionalClass(json: self.basicOptionalDict1),
            let mappedBasic2 = GlossOptionalClass(json: self.basicOptionalDict2) else {
                XCTFail("parse object failed")
                return
        }
        do {
            try self.realm.write { () -> Void in
                self.realm.add(mappedBasic1)
                self.realm.add(mappedBasic2)
                self.realm.add(emptyBadic)
            }
        } catch {
            XCTFail("realm save object error")
        }
        
        // Gloss have the ability to define yourself a way to handle parsed error
        if let _ = GlossOptionalClass(json: self.basicOptionalDict3) {
            XCTFail("In this case, Gloss will return nil object if marked non-optional whose json is nil")
        }
        
        let results = self.realm.objects(GlossOptionalClass)
        let test = Array(results)
        XCTAssert(test.count == 3)
        if let last = test.last {
            XCTAssert(last.note == nil, "last object should be empty with all value nil")
        } else {
            XCTFail("last should not be nil")
        }
        if let first = test.first {
            XCTAssert(first.note != nil, "first object note should not be nil")
        } else {
            XCTFail("last should not be nil")
        }
        
        // test toJSON
        if let json1 = mappedBasic1.toJSON(),
            let note = json1["note"] {
            XCTAssert(!(note is NSNull), "custom encode non-nil value should not be NSNull")
        } else {
            XCTFail("GlossOptionalClass toJSON should success")
        }
        if let json2 = mappedBasic2.toJSON(),
            let note = json2["note"] {
            XCTAssert(note is NSNull, "custom encode nil value should be parsed as NSNull")
        } else {
            XCTFail("GlossOptionalClass toJSON should success")
        }
    }
    
    func testUnboxClass() {
        let emptyBadic = UnboxClass.init()
        guard let mappedBasic1: UnboxClass = Unbox(self.basicDict1),
            let mappedBasic2: UnboxClass = Unbox(self.basicDict2) else {
                XCTFail("parse object failed")
                return
        }
        
        do {
            try self.realm.write { () -> Void in
                self.realm.add(mappedBasic1)
                self.realm.add(mappedBasic2)
                self.realm.add(emptyBadic)
            }
        } catch {
            XCTFail("realm save object error")
        }
        
        let results = self.realm.objects(UnboxClass)
        let test = Array(results)
        XCTAssert(test.count == 3)
        if let last = test.last {
            XCTAssert(last.name == "", "last object should be empty with default value")
        } else {
            XCTFail("last should not be nil")
        }
        if let first = test.first {
            XCTAssert(first.birthday != "", "first object birthday should not be default value")
        } else {
            XCTFail("last should not be nil")
        }
    }
    
    func testUnboxOptionalClass() {
        let emptyBadic = UnboxOptionalClass.init()
        guard let mappedBasic1: UnboxOptionalClass = Unbox(self.basicOptionalDict1),
            let mappedBasic2: UnboxOptionalClass = Unbox(self.basicOptionalDict2) else {
                XCTFail("parse object failed")
                return
        }
        do {
            try self.realm.write { () -> Void in
                self.realm.add(mappedBasic1)
                self.realm.add(mappedBasic2)
                self.realm.add(emptyBadic)
            }
        } catch {
            XCTFail("realm save object error")
        }
        
        // Unbox can return nil or throw error when parsed error
        if let _: UnboxOptionalClass = Unbox(self.basicOptionalDict3) {
            XCTFail("Unbox can return nil if use Unbox(json)")
        }
        
        do {
            let _: UnboxOptionalClass = try UnboxOrThrow(self.basicOptionalDict3)
            XCTFail("Genome will throw error if marked non-optional whose json is nil")
        } catch {
            
        }
        
        let results = self.realm.objects(UnboxOptionalClass)
        let test = Array(results)
        XCTAssert(test.count == 3)
        if let last = test.last {
            XCTAssert(last.note == nil, "last object should be empty with all value nil")
        } else {
            XCTFail("last should not be nil")
        }
        if let first = test.first {
            XCTAssert(first.note != nil, "first object note should not be nil")
        } else {
            XCTFail("last should not be nil")
        }
        
    }
    
    func testFreddyClass() {
        do {
            let data1 = try NSJSONSerialization.dataWithJSONObject(self.basicDict1, options: .PrettyPrinted)
            let json1 = try Freddy.JSON.init(data: data1)
            let data2 = try NSJSONSerialization.dataWithJSONObject(self.basicDict2, options: .PrettyPrinted)
            let json2 = try Freddy.JSON.init(data: data2)
            let mappedBasic1 = try FreddyClass.init(json: json1)
            let mappedBasic2 = try FreddyClass.init(json: json2)
            let emptyBadic = FreddyClass.init()
            try self.realm.write { () -> Void in
                self.realm.add(mappedBasic1)
                self.realm.add(mappedBasic2)
                self.realm.add(emptyBadic)
            }
        } catch is Freddy.JSON.Error {
            XCTFail("freddy mapped object error")
        } catch {
            XCTFail("realm save object error")
        }
        let results = self.realm.objects(FreddyClass)
        let test = Array(results)
        XCTAssert(test.count == 3)
        if let last = test.last {
            XCTAssert(last.name == "", "last object should be empty with default value")
        } else {
            XCTFail("last should not be nil")
        }
        if let first = test.first {
            XCTAssert(first.birthday != "", "first object birthday should not be default value")
        } else {
            XCTFail("last should not be nil")
        }
    }
    
    func testFreddyOptionalClass() {
        do {
            let data1 = try NSJSONSerialization.dataWithJSONObject(self.basicOptionalDict1, options: .PrettyPrinted)
            let jsonOption1 = try Freddy.JSON.init(data: data1)
            let data2 = try NSJSONSerialization.dataWithJSONObject(self.basicOptionalDict2, options: .PrettyPrinted)
            let jsonOption2 = try Freddy.JSON.init(data: data2)
            
            let mappedBasic1 = try OptionalFreddyClass.init(json: jsonOption1)
            let mappedBasic2 = try OptionalFreddyClass.init(json: jsonOption2)
            let emptyBadic = OptionalFreddyClass.init()
            try self.realm.write { () -> Void in
                self.realm.add(mappedBasic1)
                self.realm.add(mappedBasic2)
                self.realm.add(emptyBadic)
            }
          
        } catch is Freddy.JSON.Error {
            XCTFail("freddy parse object error")
        } catch {
            XCTFail("realm save object error")
        }

        do {
            let data3 = try NSJSONSerialization.dataWithJSONObject(self.basicOptionalDict3, options: .PrettyPrinted)
            let jsonOption3 = try Freddy.JSON.init(data: data3)
            let _ = try OptionalFreddyClass.init(json: jsonOption3)
            XCTFail("parse nil value to nonoptional attribute should throw error")
        } catch {
            // Freddy will throw error if marked non-optional whose json is nil
        }
//
        let results = self.realm.objects(OptionalFreddyClass)
        let test = Array(results)
        XCTAssert(test.count == 3)
        if let last = test.last {
            XCTAssert(last.note == nil, "last object should be empty with all value nil")
        } else {
            XCTFail("last should not be nil")
        }
        if let first = test.first {
            XCTAssert(first.note != nil, "first object note should not be nil")
        } else {
            XCTFail("last should not be nil")
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            
        }
    }
    
}
