//
//  UITableView-Extension.swift
//  RealmWrapperExample
//
//  Created by DongHeeKang on 2018. 6. 10..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerWithCellReuseIdentifier<CellClass: UITableViewCell>(_ cellClass: CellClass.Type) {
        self.register(cellClass, forCellReuseIdentifier: cellClass.className)
    }
    
}
