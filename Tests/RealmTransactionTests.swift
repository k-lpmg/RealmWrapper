//
//  RealmTransactionTests.swift
//  RealmWrapperTests
//
//  Created by DongHeeKang on 2018. 7. 28..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import XCTest

import RealmSwift

class RealmTransactionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testDefaultTransaction() {
        let users = UserInMemoryRealmProxy().users
        let userCount = 10
        
        InMemoryRealmManager.shared.transaction(writeHandler: { (realm) in
            self.addUser(count: userCount, realm: realm)
        })
        
        XCTAssertEqual(users.count, userCount)
    }
    
    func testDefaultAsyncTransaction() {
        let expectation = self.expectation(description: "testCreateNotification")
        
        let users = UserInMemoryRealmProxy().users
        let userCount = 10
        
        InMemoryRealmManager.shared.transaction(isSync: false, writeHandler: { (realm) in
            self.addUser(count: userCount, realm: realm)
        }) {
            XCTAssertEqual(users.count, userCount)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60)
    }
    
    func testCustomSyncTransaction() {
        let users = UserInMemoryRealmProxy().users
        let userCount = 10
        
        InMemoryRealmManager.shared.transaction(dispatchQueue: DispatchQueue(label: "testCustomSyncTransaction"), writeHandler: { (realm) in
            self.addUser(count: userCount, realm: realm)
        })
        
        XCTAssertEqual(users.count, userCount)
    }
    
    func testCustomAsyncTransaction() {
        let expectation = self.expectation(description: "testCreateNotification")
        
        let users = UserInMemoryRealmProxy().users
        let userCount = 10
        
        InMemoryRealmManager.shared.transaction(dispatchQueue: DispatchQueue(label: "testCustomAsyncTransaction"), isSync: false, writeHandler: { (realm) in
            self.addUser(count: userCount, realm: realm)
        }) {
            XCTAssertEqual(users.count, userCount)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60)
    }
    
    // MARK: - Private methods
    
    private func addUser(count: Int, realm: Realm) {
        for i in 0..<count {
            let user = User(name: "user-\(i)", age: i)
            realm.add(user)
        }
    }
    
}
