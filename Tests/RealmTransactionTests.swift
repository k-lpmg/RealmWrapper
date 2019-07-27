import XCTest

import RealmSwift

class RealmTransactionTests: XCTestCase {
    
    let userCount = 100000
    
    override func setUp() {
        super.setUp()
        
        MockUserRealmManager().clear()
    }
    
    func testDefaultTransaction() {
        MockUserRealmManager().transaction(writeHandler: { (realm) in
            self.addUser(count: self.userCount, realm: realm)
            
            let users = realm.objects(MockUser.self)
            XCTAssertEqual(users.count, self.userCount)
        })
    }
    
    func testDefaultAsyncTransaction() {
        let expectation = self.expectation(description: "testCreateNotification")
        
        MockUserRealmManager().transaction(isSync: false, writeHandler: { (realm) in
            self.addUser(count: self.userCount, realm: realm)
        }) { (realm, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(realm)
            
            let users = realm!.objects(MockUser.self)
            XCTAssertEqual(users.count, self.userCount)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60)
    }
    
    func testCustomSyncTransaction() {
        MockUserRealmManager().transaction(writeQueue: DispatchQueue(label: "testCustomSyncTransaction"), writeHandler: { (realm) in
            self.addUser(count: self.userCount, realm: realm)
            
            let users = realm.objects(MockUser.self)
            XCTAssertEqual(users.count, self.userCount)
        })
    }
    
    func testCustomAsyncTransaction() {
        let expectation = self.expectation(description: "testCreateNotification")
        
        MockUserRealmManager().transaction(writeQueue: DispatchQueue(label: "testCustomAsyncTransaction"), isSync: false, writeHandler: { (realm) in
            self.addUser(count: self.userCount, realm: realm)
        }) { (realm, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(realm)
            
            let users = realm!.objects(MockUser.self)
            XCTAssertEqual(users.count, self.userCount)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60)
    }
    
    // MARK: - Private methods
    
    private func addUser(count: Int, realm: Realm) {
        for i in 0..<count {
            let user = MockUser(name: "user-\(i)", age: i)
            realm.add(user)
        }
    }
    
}
