//
//  RealmQuery.swift
//  RealmWrapper
//
//  Created by DongHeeKang on 2018. 6. 10..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import RealmSwift

public typealias RealmQueryChanged = ([Int]) -> Void

public class RealmQuery<T: Object> {

    // MARK: - Properties

    private(set) var notificationToken: NotificationToken?
    private var deleteNotificationBlock: RealmQueryChanged?
    private var insertNotificationBlock: RealmQueryChanged?
    private var modificateNotificationBlock: RealmQueryChanged?

    var results: Results<T>

    // MARK: - Con(De)structor

    init(results: Results<T>) {
        self.results = results
    }

    deinit {
        clear()
    }

    // MARK: - Public methods
    
    func deleteNotification(_ block: @escaping ([Int]) -> Void) {
        deleteNotificationBlock = block
    }
    
    func insertNotification(_ block: @escaping ([Int]) -> Void) {
        insertNotificationBlock = block
    }
    
    func modificateNotification(_ block: @escaping ([Int]) -> Void) {
        modificateNotificationBlock = block
    }

    // MARK: - Private methods
    
    private func addNotification() {
        notificationClear()
        notificationToken = results.observe { [weak self] (change) in
            guard let weakSelf = self else {return}
            
            switch change {
            case .update(_, let deletions, let insertions, let modifications):
                weakSelf.deleteNotificationBlock?(deletions)
                weakSelf.insertNotificationBlock?(insertions)
                weakSelf.modificateNotificationBlock?(modifications)
            default:
                break
            }
        }
    }

    private func clear() {
        notificationClear()
    }
    
    private func notificationClear() {
        notificationToken?.invalidate()
    }

}
