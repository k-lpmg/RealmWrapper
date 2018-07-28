//
//  RealmProxiable.swift
//  RealmWrapper
//
//  Created by DongHeeKang on 2018. 6. 10..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import RealmSwift

public protocol RealmProxiable {
    associatedtype RealmManager where RealmManager: RealmManageable
}

public extension RealmProxiable {
    
    func realmManager() -> RealmManager {
        return RealmManager.shared
    }
    
    func query<T: Object>(_ type: T.Type = T.self, filter: String? = nil, sortProperty: String? = nil, ordering: OrderingType = .ascending) -> RealmQuery<T> {
        let realm = try! Realm(configuration: realmManager().configuration())
        var results = realm.objects(type)
        if let filter = filter {
            results = results.filter(filter)
        }
        if let sortProperty = sortProperty {
            results = results.sorted(byKeyPath: sortProperty, ascending: ordering == .ascending)
        }
        
        return RealmQuery(results: results)
    }
    
}
