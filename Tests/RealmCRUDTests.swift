import XCTest
@testable import RealmWrapper

import RealmSwift

class RealmCRUDTests: XCTestCase {
    
    var users = MockUserRealmProxy().users
    
    override func setUp() {
        super.setUp()
        
        MockUserRealmProxy().deleteAll()
        XCTAssertEqual(users.count, 0)
    }
    
    func testCreate() {
        let user = MockUser(name: "user1", age: 1)
        MockUserRealmProxy().append(user)
        
        XCTAssertEqual(MockUserRealmProxy().users.count, 1)
    }
    
    func testRead() {
        let user1 = MockUser(name: "user1", age: 1)
        let user2 = MockUser(name: "user2", age: 2)
        let user3 = MockUser(name: "user3", age: 3)
        let user4 = MockUser(name: "user4", age: 4)
        let user5 = MockUser(name: "user5", age: 5)
        let user6 = MockUser(name: "user6", age: 6)
        
        MockUserRealmProxy().append(user1)
        MockUserRealmProxy().append(user2)
        MockUserRealmProxy().append(user3)
        MockUserRealmProxy().append(user4)
        MockUserRealmProxy().append(user5)
        MockUserRealmProxy().append(user6)
        
        let evenUser = MockUserRealmProxy().userWithFilter("age > 3")
        XCTAssertEqual(users.count, 6)
        XCTAssertEqual(evenUser.count, 3)
    }
    
    func testUpdate() {
        let name1 = "user1"
        let age1 = 1
        let user = MockUser(name: name1, age: age1)
        
        XCTAssertNotNil(user.id)
        let userId = user.id
        
        MockUserRealmProxy().append(user)
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.results?.first?.id, userId)
        XCTAssertEqual(users.results?.first?.name, name1)
        XCTAssertEqual(users.results?.first?.age, age1)
        
        MockUserRealmProxy().updateName(id: userId!, name: "user2", age: 2)
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.results?.first?.id, userId)
        XCTAssertNotEqual(users.results?.first?.name, name1)
        XCTAssertNotEqual(users.results?.first?.age, age1)
    }
    
    func testDelete() {
        let user = MockUser(name: "user1", age: 1)
        
        MockUserRealmProxy().append(user)
        XCTAssertEqual(users.count, 1)
        
        MockUserRealmProxy().delete(user)
        XCTAssertEqual(users.count, 0)
    }
    
}
