import RealmWrapper

struct MockUserInMemoryRealmProxy<RealmManager: MockInMemoryRealmManager>: RealmProxiable {
    
    // MARK: - Properties
    
    var users: RealmQuery<MockUser> {
        return query(sortProperty: "date", ordering: .ascending)
    }
    
    // MARK: Methods
    
    func append(_ user: MockUser) {
        rm.transaction(writeHandler: { (realm) in
            realm.add(user, update: .all)
        })
    }
    
    func append(_ users: [MockUser], isSync: Bool, completion: (() -> Void)? = nil) {
        rm.transaction(isSync: isSync, writeHandler: { (realm) in
            realm.add(users, update: .all)
        }) { (realm, error) in
            completion?()
        }
    }
    
    func delete(_ user: MockUser) {
        rm.transaction(writeHandler: { (realm) in
            realm.delete(user)
        })
    }
    
    func updateName(id: String, name: String, age: Int) {
        guard let user = userFromId(id) else {return}
        
        rm.transaction(writeHandler: { (realm) in
            user.name = name
            user.age = age
            realm.add(user, update: .all)
        })
    }
    
    func userFromId(_ id: String) -> MockUser? {
        return query(filter: .string("id == '\(id)'")).results?.first
    }
    
}
