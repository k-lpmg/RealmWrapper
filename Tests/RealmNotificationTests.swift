//
//  RealmNotificationTests.swift
//  RealmWrapperTests
//
//  Created by DongHeeKang on 2018. 7. 1..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import XCTest
@testable import RealmWrapper

import RealmSwift

class RealmNotificationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        UserRealmProxy().deleteAll()
    }
    
    func testCreateNotification() {
        let expectation = self.expectation(description: "testCreateNotification")
        
        let users = UserRealmProxy().users
        users.addInsertNotificationBlock(self) { (self, insertions) in
            XCTAssertTrue(insertions.count > 0)
            
            expectation.fulfill()
        }
        .registerNotification()
        
        let user = User(name: "user1", age: 1)
        UserRealmProxy().append(user)
        
        waitForExpectations(timeout: 60)
    }
    
    func testUpdateNotification() {
        let expectation = self.expectation(description: "testUpdateNotification")
        
        let users = UserRealmProxy().users
        users.addModificateNotificationBlock(self) { (self, modifications) in
            XCTAssertTrue(modifications.count > 0)
            
            expectation.fulfill()
        }
        .registerNotification()
        
        let user = User(name: "user1", age: 1)
        let userId = user.id
        UserRealmProxy().append(user)
        
        XCTAssertNotNil(userId)
        UserRealmProxy().updateName(id: userId!, name: "user2", age: 2)
        
        waitForExpectations(timeout: 60)
    }
    
    func testDeleteNotification() {
        let expectation = self.expectation(description: "testDeleteNotification")
        
        let users = UserRealmProxy().users
        users.addDeleteNotificationBlock(self) { (self, deletions) in
            XCTAssertTrue(deletions.count > 0)
            
            expectation.fulfill()
        }
        .registerNotification()
        
        let user = User(name: "user2", age: 2)
        UserRealmProxy().append(user)
        
        UserRealmProxy().delete(user)
        
        waitForExpectations(timeout: 60)
    }
    
}
