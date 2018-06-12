//
//  DiskRealmManager.swift
//  RealmWrapperExample
//
//  Created by DongHeeKang on 2018. 6. 11..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import RealmWrapper

final class DiskRealmManager: RealmManageable {
    
    static var shared: DiskRealmManager = DiskRealmManager()
    
    var isUseInMemory: Bool {
        return false
    }
    var schemaVersion: UInt64 {
        return 1
    }
    var fileName: String {
        return "disk"
    }
    
}
