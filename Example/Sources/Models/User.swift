//
//  User.swift
//  RealmWrapperExample
//
//  Created by DongHeeKang on 2018. 6. 30..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import Foundation

import RealmSwift

@objcMembers
class User: Object {
    
    dynamic var age: Int = 0
    dynamic var date: Int = 0
    dynamic var id: String?
    dynamic var name: String?
    
    convenience init(name: String, age: Int) {
        self.init()
        
        id = UUID().uuidString
        date = Date().timeIntervalSince1970.hashValue
        self.name = name
        self.age = age
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
