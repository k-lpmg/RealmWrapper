import UIKit

import RealmSwift
import RealmWrapper

final class MultipleAddViewController: UIViewController {
    
    // MARK: - Properties
    
    private var isCountValid: Bool = false {
        didSet {
            saveButtonItem.isEnabled = isCountValid
        }
    }
    private let useSyncLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.text = "Use Sync"
        return label
    }()
    private let useSyncSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
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
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.text = "Count"
        return label
    }()
    private let countTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.textAlignment = .right
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
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
        view.addSubview(useSyncLabel)
        view.addSubview(useSyncSwitch)
        view.addSubview(useInMemoryLabel)
        view.addSubview(useInMemorySwitch)
        view.addSubview(countLabel)
        view.addSubview(countTextField)
        layout()
    }
    
    // MARK: - Private methods
    
    private func setNavigation() {
        title = "Add multiple user"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        navigationItem.rightBarButtonItem = saveButtonItem
    }
    
    private func setProperties() {
        view.backgroundColor = .white
    }
    
    private func setSelector() {
        countTextField.addTarget(self, action: #selector(countTextFieldEditingChanged(sender:)), for: .editingChanged)
    }
    
    // MARK: - Private selector
    
    @objc private func countTextFieldEditingChanged(sender: UITextField) {
        guard let text = sender.text else {return}
        
        isCountValid = !text.isEmpty
    }
    
    @objc private func saveButtonDidClicked() {
        guard let text = countTextField.text, let count = Int(text) else {return}
        
        DispatchQueue.global().async {
            var users = [User]()
            (0...count).forEach({ (i) in
                let user = User(name: "\(i)", age: i)
                users.append(user)
            })
            
            DispatchQueue.main.async {
                if self.useInMemorySwitch.isOn {
                    UserInMemoryRealmProxy().append(users, isSync: self.useSyncSwitch.isOn, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                } else {
                    UserRealmProxy().append(users, isSync: self.useSyncSwitch.isOn, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
}

// MARK: - Layout

extension MultipleAddViewController {
    
    private func layout() {
        useSyncLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        useSyncLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 32).isActive = true
        useSyncLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        useSyncSwitch.topAnchor.constraint(equalTo: useSyncLabel.topAnchor).isActive = true
        useSyncSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        useInMemoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        useInMemoryLabel.topAnchor.constraint(equalTo: useSyncLabel.bottomAnchor, constant: 32).isActive = true
        useInMemoryLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        useInMemorySwitch.topAnchor.constraint(equalTo: useInMemoryLabel.topAnchor).isActive = true
        useInMemorySwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        countLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        countLabel.topAnchor.constraint(equalTo: useInMemoryLabel.bottomAnchor, constant: 32).isActive = true
        countLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        countTextField.topAnchor.constraint(equalTo: countLabel.topAnchor).isActive = true
        countTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        countTextField.widthAnchor.constraint(equalToConstant: 85).isActive = true
        countTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
}

