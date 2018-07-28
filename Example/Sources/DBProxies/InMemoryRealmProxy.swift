import RealmWrapper

struct UserInMemoryRealmProxy<RealmManager: InMemoryRealmManager>: RealmProxiable {
    
    // MARK: - Properties
    
    var users: RealmQuery<User> {
        return query(sortProperty: "date", ordering: .ascending)
    }
    
    // MARK: Methods
    
    func append(_ user: User) {
        realmManager().transaction(writeHandler: { (realm) in
            realm.add(user, update: true)
        })
    }
    
    func delete(_ user: User) {
        realmManager().transaction(writeHandler: { (realm) in
            realm.delete(user)
        })
    }
    
    func updateName(id: String, name: String, age: Int) {
        guard let user = userFromId(id) else {return}
        
        realmManager().transaction(writeHandler: { (realm) in
            user.name = name
            user.age = age
            realm.add(user, update: true)
        })
    }
    
    func userFromId(_ id: String) -> User? {
        return query(filter: "id == '\(id)'").results.first
    }
    
}
