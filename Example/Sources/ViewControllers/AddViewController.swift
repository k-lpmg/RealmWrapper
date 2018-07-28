import UIKit

import RealmSwift
import RealmWrapper

final class AddViewController: UIViewController {
    
    // MARK: - Properties
    
    private var isNameValid: Bool = false {
        didSet {
            saveButtonItem.isEnabled = isNameValid && isAgeValid
        }
    }
    private var isAgeValid: Bool = false {
        didSet {
            saveButtonItem.isEnabled = isNameValid && isAgeValid
        }
    }
    private let useInMemoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.text = "Use InMemory"
        return label
    }()
    private let useInMemorySwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
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
        buttonItem.isEnabled = false
        return buttonItem
    }()
    
    // MARK: - Overridden: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setProperties()
        setSelector()
        view.addSubview(useInMemoryLabel)
        view.addSubview(useInMemorySwitch)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(ageLabel)
        view.addSubview(ageTextField)
        layout()
    }
    
    // MARK: - Private methods
    
    private func setNavigation() {
        title = "Add User"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        navigationItem.rightBarButtonItem = saveButtonItem
    }
    
    private func setProperties() {
        view.backgroundColor = .white
    }
    
    private func setSelector() {
        nameTextField.addTarget(self, action: #selector(nameTextFieldEditingChanged(sender:)), for: .editingChanged)
        ageTextField.addTarget(self, action: #selector(ageTextFieldEditingChanged(sender:)), for: .editingChanged)
    }
    
    // MARK: - Private selector
    
    @objc private func saveButtonDidClicked() {
        guard let name = nameTextField.text, let ageText = ageTextField.text, let age = Int(ageText) else {return}
        
        let user = User(name: name, age: age)
        if useInMemorySwitch.isOn {
            UserInMemoryRealmProxy().append(user)
        } else {
            UserRealmProxy().append(user)
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

extension AddViewController {
    
    private func layout() {
        useInMemoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        useInMemoryLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 32).isActive = true
        useInMemoryLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        useInMemorySwitch.topAnchor.constraint(equalTo: useInMemoryLabel.topAnchor).isActive = true
        useInMemorySwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        nameLabel.topAnchor.constraint(equalTo: useInMemoryLabel.bottomAnchor, constant: 32).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        
        ageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 32).isActive = true
        ageLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        ageTextField.leadingAnchor.constraint(equalTo: ageLabel.trailingAnchor, constant: 16).isActive = true
        ageTextField.topAnchor.constraint(equalTo: ageLabel.topAnchor).isActive = true
        ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
    }
    
}

