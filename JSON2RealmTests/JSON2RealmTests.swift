//
//  JSON2RealmTests.swift
//  JSON2RealmTests
//
//  Created by Wane Wang on 2015/12/22.
//  Copyright © 2015年 Wane Wang. All rights reserved.
//

import XCTest
import Genome
import RealmSwift
@testable import JSON2Realm

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
    
    func testBasicClass() {
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
            let mappedBasic1 = try BasicClass.mappedInstance(dict)
            let mappedBasic2 = try BasicClass.mappedInstance(dict2)
            let emptyBadic = BasicClass.init()
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
        let results = self.realm.objects(BasicClass)
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
    
    func testBasicOptionalClass() {
        let dict = [
            "note": "abc"
        ]
        let dict2 = [
            "distance": 13
        ]
        do {
            let mappedBasic1 = try BasicOptionalClass.mappedInstance(dict)
            let mappedBasic2 = try BasicOptionalClass.mappedInstance(dict2)
            let emptyBadic = BasicOptionalClass.init()
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
        let results = self.realm.objects(BasicOptionalClass)
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
