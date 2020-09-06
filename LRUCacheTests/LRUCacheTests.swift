//
//  LRUCacheTests.swift
//  LRUCacheTests
//
//  Created by Saurabh Gupta on 04/09/20.
//  Copyright © 2020 Saurabh Gupta. All rights reserved.
//

import XCTest
@testable import LRUCache

class LRUCacheTests: XCTestCase {

    func testGetValueIfKeyExistInCache() throws {
        let cache = LRUCache<Int, String>(capacity: 2)
        cache.setObject("Saurabh", for: 1)
        cache.setObject("Jiajia", for: 2)
        
        let value = cache.getValue(for: 1)
        XCTAssertTrue(value == "Saurabh", "Expected value: Saurabh")
    }
    
    func testGetValueIfKeyDoesNotExistInCache() throws {
        let cache = LRUCache<Int, String>(capacity: 2)
        cache.setObject("Saurabh", for: 1)
        cache.setObject("Jiajia", for: 2)
        
        let value = cache.getValue(for: 3)
        XCTAssertNil(value, "Expected value: nil")
    }
    
    func testRecentlyUsedItemInvalidation() throws {
        let cache = LRUCache<Int, String>(capacity: 2)
        cache.setObject("Saurabh", for: 1)
        cache.setObject("Jiajia", for: 2)
        cache.setObject("Kevin", for: 3)
        
        let value = cache.getValue(for: 1)
        XCTAssertNil(value, "Key 1 was least recently used")
    }
    
    func testGetValueShouldUpdateLeastRecentUsedObject() throws {
        let cache = LRUCache<Int, String>(capacity: 2)
        cache.setObject("Saurabh", for: 1)
        cache.setObject("Jiajia", for: 2)
        
        var value = cache.getValue(for: 1) // This will make key 2 least recently used
        
        cache.setObject("Kevin", for: 3)
        
        value = cache.getValue(for: 2)

        XCTAssertNil(value, "Key 2 was least recently used")
    }
    
    func testSetObjectWithDuplicateKey() throws {
        let cache = LRUCache<Int, String>(capacity: 2)
        cache.setObject("Saurabh", for: 1)
        cache.setObject("Jiajia", for: 2)
        
        cache.setObject("Kevin", for: 1) // duplicate key
        
        let value = cache.getValue(for: 1)
        XCTAssertTrue(value == "Saurabh", "Value still same, duplicate key was rejected")
    }
    
}
