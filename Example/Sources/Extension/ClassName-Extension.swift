//
//  ClassName-Extension.swift
//  RealmWrapperExample
//
//  Created by DongHeeKang on 2018. 6. 30..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import Foundation

protocol ClassName {
    static var className: String { get }
}

// Swift Objects
extension ClassName {
    
    static var className: String {
        return String(describing: self).components(separatedBy: " ").first!
    }
    
}

// Bridge to Obj-C
extension NSObject: ClassName {
    
    class var className: String {
        return String(describing: self).components(separatedBy: " ").first!
    }
    
}
