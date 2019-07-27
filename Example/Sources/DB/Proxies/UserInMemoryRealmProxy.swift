import RealmWrapper

struct UserInMemoryRealmProxy<RealmManager: InMemoryRealmManager>: RealmProxiable {
    
    // MARK: - Properties
    
    var users: RealmQuery<User> {
        return query(sortProperty: "date", ordering: .ascending)
    }
    
    // MARK: Methods
    
    func append(_ user: User) {
        rm.transaction(writeHandler: { (realm) in
            realm.add(user, update: .all)
        })
    }
    
    func append(_ users: [User], isSync: Bool, completion: (() -> Void)? = nil) {
        rm.transaction(isSync: isSync, writeHandler: { (realm) in
            realm.add(users, update: .all)
        }) { (realm, error) in
            completion?()
        }
    }
    
    func delete(_ user: User) {
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
    
    func userFromId(_ id: String) -> User? {
        return query(filter: "id == '\(id)'").results.first
    }
    
}
