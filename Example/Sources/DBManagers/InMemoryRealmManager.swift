//
//  InMemoryRealmManager.swift
//  RealmWrapperExample
//
//  Created by DongHeeKang on 2018. 6. 30..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import RealmSwift
import RealmWrapper

final class InMemoryRealmManager: RealmManageable {
    
    static var shared: InMemoryRealmManager = InMemoryRealmManager()
    
    var isUseInMemory: Bool {
        return true
    }
    var schemaVersion: UInt64 {
        return 1
    }
    var fileName: String {
        return "inMemory"
    }
    var objectTypes: [Object.Type]? {
        return [User.self]
    }
    
}
