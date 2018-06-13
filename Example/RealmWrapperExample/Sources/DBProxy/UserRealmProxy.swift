//
//  UserRealmProxy.swift
//  RealmWrapperExample
//
//  Created by DongHeeKang on 2018. 6. 11..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import RealmWrapper

struct UserRealmProxy<RealmManager: UserRealmManager>: RealmProxiable {
    
    // MARK: - Properties
    
    var users: RealmQuery<User> {
        return query(sortProperty: "date", ordering: .ascending)
    }
    
    // MARK: Methods
    
    func append(_ user: User) {
        transaction { (realm) in
            realm.add(user, update: true)
        }
    }
    
    func delete(_ user: User) {
        transaction { (realm) in
            realm.delete(user)
        }
    }
    
    func updateName(id: String, name: String, age: Int) {
        guard let user = userFromId(id) else {return}
        transaction { (realm) in
            user.name = name
            user.age = age
            realm.add(user, update: true)
        }
    }
    
    func userFromId(_ id: String) -> User? {
        return query(filter: "id == '\(id)'").results.first
    }
    
}
