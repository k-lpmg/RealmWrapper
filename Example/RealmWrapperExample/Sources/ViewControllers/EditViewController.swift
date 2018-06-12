//
//  EditViewController.swift
//  RealmWrapperExample
//
//  Created by DongHeeKang on 2018. 6. 10..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import UIKit

final class EditViewController: UIViewController {
    
    // MARK: - Properties
    
    private var isUseInMemory: Bool = false
    private var id: String!
    private var user: User?
    private var isNameValid: Bool = true {
        didSet {
            saveButtonItem.isEnabled = isNameValid && isAgeValid
        }
    }
    private var isAgeValid: Bool = true {
        didSet {
            saveButtonItem.isEnabled = isNameValid && isAgeValid
        }
    }
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.text = "Name"
        return label
    }()
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Please enter user's name."
        return textField
    }()
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.text = "Age"
        return label
    }()
    private let ageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Please enter user's age."
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var saveButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonDidClicked))
        return buttonItem
    }()
    
    // MARK: - Con(De)structor
    
    convenience init(isUseInMemory: Bool = false, id: String) {
        self.init()
        
        self.isUseInMemory = isUseInMemory
        self.id = id
        if isUseInMemory {
            user = UserInMemoryRealmProxy().userFromId(id)
        } else {
            user = UserRealmProxy().userFromId(id)
        }
    }
    
    // MARK: - Overridden: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setProperties()
        setSelector()
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(ageLabel)
        view.addSubview(ageTextField)
        layout()
    }
    
    // MARK: - Private methods
    
    private func setNavigation() {
        title = "Edit User"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        navigationItem.rightBarButtonItem = saveButtonItem
    }
    
    private func setProperties() {
        view.backgroundColor = .white
        nameTextField.text = user?.name
        ageTextField.text = user?.age.description
    }
    
    private func setSelector() {
        nameTextField.addTarget(self, action: #selector(nameTextFieldEditingChanged(sender:)), for: .editingChanged)
        ageTextField.addTarget(self, action: #selector(ageTextFieldEditingChanged(sender:)), for: .editingChanged)
    }
    
    // MARK: - Private selector
    
    @objc private func saveButtonDidClicked() {
        guard let name = nameTextField.text, let ageText = ageTextField.text, let age = Int(ageText) else {return}
        
        if isUseInMemory {
            UserInMemoryRealmProxy().updateName(id: id, name: name, age: age)
        } else {
            UserRealmProxy().updateName(id: id, name: name, age: age)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nameTextFieldEditingChanged(sender: UITextField) {
        guard let text = sender.text else {return}
        
        isNameValid = !text.isEmpty
    }
    
    @objc private func ageTextFieldEditingChanged(sender: UITextField) {
        guard let text = sender.text else {return}
        
        isAgeValid = !text.isEmpty
    }
    
}

// MARK: - Layout

extension EditViewController {
    
    private func layout() {
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 32).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        
        ageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
        ageLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        ageTextField.leadingAnchor.constraint(equalTo: ageLabel.trailingAnchor, constant: 16).isActive = true
        ageTextField.topAnchor.constraint(equalTo: ageLabel.topAnchor).isActive = true
        ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
    }
    
}
