//
//  UserTableViewCell.swift
//  RealmWrapperExample
//
//  Created by DongHeeKang on 2018. 6. 30..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var model: User? {
        didSet {
            guard let model = model else {return}
            
            textLabel?.text = model.name
            detailTextLabel?.text = model.age.description
        }
    }
    
    // MARK: - Con(De)structor
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
