//
//  RealmCRUDTests.swift
//  RealmWrapperTests
//
//  Created by DongHeeKang on 2018. 7. 1..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import XCTest
@testable import RealmWrapper

import RealmSwift

class RealmCRUDTests: XCTestCase {
    
    var users = UserRealmProxy().users
    
    override func setUp() {
        super.setUp()
        
        UserRealmProxy().deleteAll()
        XCTAssertEqual(users.count, 0)
    }
    
    func testCreate() {
        let user = User(name: "user1", age: 1)
        UserRealmProxy().append(user)
        
        XCTAssertEqual(UserRealmProxy().users.count, 1)
    }
    
    func testRead() {
        let user1 = User(name: "user1", age: 1)
        let user2 = User(name: "user2", age: 2)
        let user3 = User(name: "user3", age: 3)
        let user4 = User(name: "user4", age: 4)
        let user5 = User(name: "user5", age: 5)
        let user6 = User(name: "user6", age: 6)
        
        UserRealmProxy().append(user1)
        UserRealmProxy().append(user2)
        UserRealmProxy().append(user3)
        UserRealmProxy().append(user4)
        UserRealmProxy().append(user5)
        UserRealmProxy().append(user6)
        
        let evenUser = UserRealmProxy().userWithFilter("age > 3")
        XCTAssertEqual(users.count, 6)
        XCTAssertEqual(evenUser.count, 3)
    }
    
    func testUpdate() {
        let name1 = "user1"
        let age1 = 1
        let user = User(name: name1, age: age1)
        
        XCTAssertNotNil(user.id)
        let userId = user.id
        
        UserRealmProxy().append(user)
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.results.first?.id, userId)
        XCTAssertEqual(users.results.first?.name, name1)
        XCTAssertEqual(users.results.first?.age, age1)
        
        UserRealmProxy().updateName(id: userId!, name: "user2", age: 2)
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.results.first?.id, userId)
        XCTAssertNotEqual(users.results.first?.name, name1)
        XCTAssertNotEqual(users.results.first?.age, age1)
    }
    
    func testDelete() {
        let user = User(name: "user1", age: 1)
        
        UserRealmProxy().append(user)
        XCTAssertEqual(users.count, 1)
        
        UserRealmProxy().delete(user)
        XCTAssertEqual(users.count, 0)
    }
    
}
