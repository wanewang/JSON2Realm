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
import RealmSwift

class JSON2RealmTests: XCTestCase {
    var realm: Realm!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        self.realm = try! Realm()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGenomeClass() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let dict = [
            "name": "abc",
            "birthday": "1988-02-03",
            "age": 13
        ]
        let dict2 = [
            "name": "abcdef",
            "birthday": "1988-01-02",
            "age": 50
        ]
        do {
            let mappedBasic1 = try GenomeClass.mappedInstance(dict)
            let mappedBasic2 = try GenomeClass.mappedInstance(dict2)
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
        let dict = [
            "note": "abc",
            "value": 3
        ]
        let dict2 = [
            "distance": 13,
            "value": 4
        ]
        do {
            let mappedBasic1 = try OptionalGenomeClass.mappedInstance(dict)
            let mappedBasic2 = try OptionalGenomeClass.mappedInstance(dict2)
            let emptyBadic = OptionalGenomeClass.init()
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
        
        let dict3 = [
            "note": "def"
        ]
        
        do {
            let _ = try OptionalGenomeClass.mappedInstance(dict3)
            XCTFail("parse nil value to nonoptional attribute should throw error")
        } catch {
            
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
        let dict = [
            "name": "abc",
            "birthday": "1988-02-03",
            "age": 13
        ]
        let dict2 = [
            "name": "abcdef",
            "birthday": "1988-01-02",
            "age": 50
        ]
        do {
            let mappedBasic1 = Mapper<ObjectMapperClass>().map(dict)!
            let mappedBasic2 = Mapper<ObjectMapperClass>().map(dict2)!
            let emptyBadic = ObjectMapperClass.init()
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
        let dict = [
            "note": "abc",
            "value": 3
        ]
        let dict2 = [
            "distance": 13,
            "value": 4
        ]
        do {
            let mappedBasic1 = Mapper<ObjectMapperOptionalClass>().map(dict)!
            let mappedBasic2 = Mapper<ObjectMapperOptionalClass>().map(dict2)!
            let emptyBadic = ObjectMapperOptionalClass.init()
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
        
        let dict3 = [
            "note": "def"
        ]
        
        if let mappedBasic3 = Mapper<ObjectMapperOptionalClass>().map(dict3) {
            print(Mapper().toJSONString(mappedBasic3))
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            
        }
    }
    
}
