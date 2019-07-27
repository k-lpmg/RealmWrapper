import XCTest
@testable import RealmWrapper

import RealmSwift

class RealmNotificationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        MockUserRealmProxy().deleteAll()
    }
    
    func testCreateNotification() {
        let expectation = self.expectation(description: "testCreateNotification")
        
        let users = MockUserRealmProxy().users
        users.addInsertNotificationBlock(self) { (self, insertions) in
            XCTAssertTrue(insertions.count > 0)
            
            expectation.fulfill()
        }
        .registerNotification()
        
        let user = MockUser(name: "user1", age: 1)
        MockUserRealmProxy().append(user)
        
        waitForExpectations(timeout: 60)
    }
    
    func testUpdateNotification() {
        let expectation = self.expectation(description: "testUpdateNotification")
        
        let users = MockUserRealmProxy().users
        users.addModificateNotificationBlock(self) { (self, modifications) in
            XCTAssertTrue(modifications.count > 0)
            
            expectation.fulfill()
        }
        .registerNotification()
        
        let user = MockUser(name: "user1", age: 1)
        let userId = user.id
        MockUserRealmProxy().append(user)
        
        XCTAssertNotNil(userId)
        MockUserRealmProxy().updateName(id: userId!, name: "user2", age: 2)
        
        waitForExpectations(timeout: 60)
    }
    
    func testDeleteNotification() {
        let expectation = self.expectation(description: "testDeleteNotification")
        
        let users = MockUserRealmProxy().users
        users.addDeleteNotificationBlock(self) { (self, deletions) in
            XCTAssertTrue(deletions.count > 0)
            
            expectation.fulfill()
        }
        .registerNotification()
        
        let user = MockUser(name: "user2", age: 2)
        MockUserRealmProxy().append(user)
        
        MockUserRealmProxy().delete(user)
        
        waitForExpectations(timeout: 60)
    }
    
}
