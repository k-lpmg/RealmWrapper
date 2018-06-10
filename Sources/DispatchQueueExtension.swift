//
//  DispatchQueueExtension.swift
//  RealmWrapper
//
//  Created by DongHeeKang on 2018. 6. 10..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    class var currentLabel: String {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))!
    }
    
    class func isCurrentQueue(queue: DispatchQueue) -> Bool {
        return currentLabel == queue.label
    }
}
