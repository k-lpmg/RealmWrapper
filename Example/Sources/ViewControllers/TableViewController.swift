import UIKit

import RealmSwift
import RealmWrapper

final class TableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private lazy var users: RealmQuery<User> = UserRealmProxy().users
    private lazy var usersInMemory: RealmQuery<User> = UserInMemoryRealmProxy().users
    
    private lazy var menuButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(settingButtonItemClicked))
        return buttonItem
    }()
    private lazy var addButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonItemClicked))
        return buttonItem
    }()
    
    // MARK: - Overridden: UITableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setProperties()
        setRealmNotification()
    }
    
    // MARK: - Private methods
    
    private func setNavigation() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            title = "People List"
        }
        navigationItem.leftBarButtonItem = menuButtonItem
        navigationItem.rightBarButtonItem = addButtonItem
    }
    
    private func setProperties() {
        tableView.estimatedSectionHeaderHeight = 20
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.registerWithCellReuseIdentifier(UserTableViewCell.self)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func setRealmNotification() {
        users.setSection(0)
            .addInsertNotificationBlock(self) { (self, insertions) in
                self.tableView.reloadData()
            }
            .addModificateNotificationBlock(self) { (self, modifications) in
                self.tableView.reloadRows(at: modifications, with: .fade)
            }
            .addDeleteNotificationBlock(self) { (self, deletions) in
                self.tableView.deleteRows(at: deletions, with: .fade)
            }
            .registerNotification()
        
        usersInMemory.setSection(1)
            .addInsertNotificationBlock(self) { (self, insertions) in
                self.tableView.reloadData()
            }
            .addModificateNotificationBlock(self) { (self, modifications) in
                self.tableView.reloadRows(at: modifications, with: .fade)
            }
            .addDeleteNotificationBlock(self) { (self, deletions) in
                self.tableView.deleteRows(at: deletions, with: .fade)
            }
            .registerNotification()
    }
    
    private func getUserFrom(indexPath: IndexPath) -> User? {
        return indexPath.section == 0 ? users[indexPath.row] : usersInMemory[indexPath.row]
    }
    
    // MARk: - Private selector
    
    @objc private func settingButtonItemClicked() {
        let editOnAction = UIAlertAction(title: "edit on", style: .default) { [unowned self] (_) in
            self.tableView.isEditing = true
        }
        let editOffAction = UIAlertAction(title: "edit off", style: .default) { [unowned self] (_) in
            self.tableView.isEditing = false
        }
        let userRealmClearAction = UIAlertAction(title: "clear user realm", style: .default) { (_) in
            UserRealmManager().clear(isSync: false)
        }
        let inMemoryRealmClear = UIAlertAction(title: "clear inMemory realm", style: .default) { (_) in
            InMemoryRealmManager().clear(isSync: false)
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        var actions = [UIAlertAction]()
        actions.append(tableView.isEditing ? editOffAction : editOnAction)
        actions.append(userRealmClearAction)
        actions.append(inMemoryRealmClear)
        actions.append(cancelAction)
        alert(preferredStyle: .actionSheet, actions: actions)
    }
    
    @objc private func addButtonItemClicked() {
        let singleAddAction = UIAlertAction(title: "single add", style: .default) { [unowned self] (_) in
            self.navigationController?.pushViewController(SingleAddViewController(), animated: true)
        }
        let multipleAddAction = UIAlertAction(title: "multiple add", style: .default) { [unowned self] (_) in
            self.navigationController?.pushViewController(MultipleAddViewController(), animated: true)
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        alert(preferredStyle: .actionSheet, actions: [singleAddAction, multipleAddAction, cancelAction])
    }
    
    @objc private func handleRefresh() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
}

// MARk: - UITableViewDataSource

extension TableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {return usersInMemory.count}
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.className, for: indexPath) as! UserTableViewCell
        cell.model = getUserFrom(indexPath: indexPath)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension TableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.estimatedSectionHeaderHeight))
        headerView.backgroundColor = UIColor.groupTableViewBackground
        
        let label: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 17)
            return label
        }()
        label.text = section == 0 ? "user realm" : "inMemory realm"
        headerView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4).isActive = true
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = getUserFrom(indexPath: indexPath)?.id else {return}
        
        let controller = EditViewController(isUseInMemory: indexPath.section != 0, id: id)
        navigationController?.pushViewController(controller, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let user = getUserFrom(indexPath: indexPath) else { return }

        if indexPath.section == 0 {
            UserInMemoryRealmProxy().delete(user)
        } else {
            UserRealmProxy().delete(user)
        }
    }
    
}
