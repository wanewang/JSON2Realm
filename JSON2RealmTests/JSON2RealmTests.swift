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
import RealmSwift

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
            let mappedBasic1 = try GenomeClass.mappedInstance(self.basicDict1)
            let mappedBasic2 = try GenomeClass.mappedInstance(self.basicDict2)
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
            let mappedBasic1 = try OptionalGenomeClass.mappedInstance(self.basicOptionalDict1)
            let mappedBasic2 = try OptionalGenomeClass.mappedInstance(self.basicOptionalDict2)
            let emptyBadic = OptionalGenomeClass.init()
            try self.realm.write { () -> Void in
                self.realm.add(mappedBasic1)
                self.realm.add(mappedBasic2)
                self.realm.add(emptyBadic)
            }
            
            // test toJSON
            let json1 = try mappedBasic1.jsonRepresentation()
            if let note = json1["note"] {
                    XCTAssert(!(note is NSNull), "custom encode non-nil value should not be NSNull")
            } else {
                XCTFail("OptionalGenomeClass jsonRepresentation should success")
            }
            let json2 = try mappedBasic2.jsonRepresentation()
            if let note = json2["note"] {
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
            let _ = try OptionalGenomeClass.mappedInstance(self.basicOptionalDict3)
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            
        }
    }
    
}
