//
//  RealmQuery.swift
//  RealmWrapper
//
//  Created by DongHeeKang on 2018. 6. 10..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import RealmSwift

public typealias RealmQueryChanged = ([IndexPath]) -> Void

final public class RealmQuery<T: Object> {

    // MARK: - Properties
    
    private var deleteNotificationBlock: RealmQueryChanged?
    private var insertNotificationBlock: RealmQueryChanged?
    private var modificateNotificationBlock: RealmQueryChanged?

    private(set) var notificationToken: NotificationToken?
    private(set) var section: Int?
    
    public var results: Results<T>
    public var count: Int {
        return results.count
    }
    
    // MARK: - Subscript
    
    public subscript(index: Int) -> T {
        return results[index]
    }

    // MARK: - Con(De)structor

    init(results: Results<T>) {
        self.results = results
    }

    deinit {
        notificationClear()
    }

    // MARK: - Public methods
    
    public func addDeleteNotificationBlock<Object: AnyObject>(_ object: Object, block: @escaping (Object, [IndexPath]) -> Void) -> Self {
        deleteNotificationBlock = { [weak object] (insertions) in
            guard let weakObject = object else {return}
            
            block(weakObject, insertions)
        }
        return self
    }
    
    public func addInsertNotificationBlock<Object: AnyObject>(_ object: Object, block: @escaping (Object, [IndexPath]) -> Void) -> Self {
        insertNotificationBlock = { [weak object] (insertions) in
            guard let weakObject = object else {return}
            
            block(weakObject, insertions)
        }
        return self
    }
    
    public func addModificateNotificationBlock<Object: AnyObject>(_ object: Object, block: @escaping (Object, [IndexPath]) -> Void) -> Self {
        modificateNotificationBlock = { [weak object] (insertions) in
            guard let weakObject = object else {return}
            
            block(weakObject, insertions)
        }
        return self
    }
    
    public func registerNotification() {
        notificationClear()
        notificationToken = results.observe { [weak self] (change) in
            guard let weakSelf = self else {return}
            
            switch change {
            case .update(_, let deletions, let insertions, let modifications):
                let indexPathsForDeletions = weakSelf.indexPathsFromInt(deletions)
                let indexPathsForInsertions = weakSelf.indexPathsFromInt(insertions)
                let indexPathsForModifications = weakSelf.indexPathsFromInt(modifications)
                
                if !deletions.isEmpty {
                    weakSelf.deleteNotificationBlock?(indexPathsForDeletions)
                }
                if !insertions.isEmpty {
                    weakSelf.insertNotificationBlock?(indexPathsForInsertions)
                }
                if !modifications.isEmpty {
                    weakSelf.modificateNotificationBlock?(indexPathsForModifications)
                }
            default:
                break
            }
        }
    }
    
    public func setSection(_ section: Int) -> Self {
        self.section = section
        return self
    }

    // MARK: - Private methods
    
    private func indexPathsFromInt(_ data: [Int]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        data.forEach { (datum) in
            indexPaths.append(IndexPath(row: datum, section: section ?? 0))
        }
        return indexPaths
    }
    
    private func notificationClear() {
        notificationToken?.invalidate()
    }

}
