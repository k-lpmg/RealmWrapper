//
//  TableViewController.swift
//  RealmWrapperExample
//
//  Created by DongHeeKang on 2018. 6. 10..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import UIKit

import RealmWrapper

final class TableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private lazy var users: RealmQuery<User> = UserRealmProxy().users
    private lazy var usersInMemory: RealmQuery<User> = UserInMemoryRealmProxy().users
    
    private lazy var addButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonItemClicked))
        return buttonItem
    }()
    
    // MARK: - Overridden: UITableViewController
    
    override var editButtonItem: UIBarButtonItem {
        let buttonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonItemClicked))
        return buttonItem
    }
    
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
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = addButtonItem
    }
    
    private func setProperties() {
        tableView.estimatedSectionHeaderHeight = 20
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
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
    
    private func getUserFrom(indexPath: IndexPath) -> User {
        return indexPath.section == 0 ? users[indexPath.row] : usersInMemory[indexPath.row]
    }
    
    // MARk: - Private selector
    
    @objc private func addButtonItemClicked() {
        let controller = AddViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func editButtonItemClicked() {
        guard tableView.isEditing else {
            tableView.isEditing = true
            navigationItem.leftBarButtonItem?.title = "Done"
            return
        }
        
        tableView.isEditing = false
        navigationItem.leftBarButtonItem?.title = "Edit"
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
        label.text = section == 0 ? "Users" : "InMemory"
        headerView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4).isActive = true
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = getUserFrom(indexPath: indexPath).id else {return}
        
        let controller = EditViewController(isUseInMemory: indexPath.section != 0, id: id)
        navigationController?.pushViewController(controller, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else {
            UserInMemoryRealmProxy().delete(getUserFrom(indexPath: indexPath))
            return
        }
        UserRealmProxy().delete(getUserFrom(indexPath: indexPath))
    }
    
}
