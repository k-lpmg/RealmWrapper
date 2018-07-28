//
//  RealmManageable.swift
//  RealmWrapper
//
//  Created by DongHeeKang on 2018. 6. 10..
//  Copyright © 2018년 k-lpmg. All rights reserved.
//

import RealmSwift
import Realm.Private

public typealias RealmWriteHandler = (Realm) -> Void

public enum OrderingType {
    case ascending, descending
}

public protocol RealmManageable {
    
    // MARK: - Constants
    
    static var shared: Self { get }
    static var defaultQueueLabel: String { get }
    static var defaultQueue: DispatchQueue { get }
    
    // MARK: - Properties
    
    var deleteRealmIfMigrationNeeded: Bool { get }
    var isUseInMemory: Bool { get }
    var readOnly: Bool { get }
    var schemaVersion: UInt64 { get }
    var fileName: String { get }
    var appGroupIdentifier: String? { get }
    var encryptionKey: Data? { get }
    var shouldCompactOnLaunch: ((Int, Int) -> Bool)? { get }
    var migrationBlock: MigrationBlock? { get }
    var syncConfiguration: SyncConfiguration? { get }
    var objectTypes: [Object.Type]? { get }
    
}

public extension RealmManageable {
    
    // MARK: - Constants
    
    static var defaultQueueLabel: String {
        return "RealmManageable"
    }
    static var defaultQueue: DispatchQueue {
        return DispatchQueue(label: Self.defaultQueueLabel)
    }
    
    // MARK: - Properties
    
    var deleteRealmIfMigrationNeeded: Bool {
        return false
    }
    var readOnly: Bool {
        return false
    }
    var appGroupIdentifier: String? {
        return nil
    }
    var encryptionKey: Data? {
        return nil
    }
    var shouldCompactOnLaunch: ((Int, Int) -> Bool)? {
        return nil
    }
    var migrationBlock: MigrationBlock? {
        return nil
    }
    var syncConfiguration: SyncConfiguration? {
        return nil
    }
    var objectTypes: [Object.Type]? {
        return nil
    }
    
    // MARK: - Internal methods
    
    func clear(dispatchQueue: DispatchQueue = Self.defaultQueue, isSync: Bool = true, completion: (() -> Void)? = nil) {
        transaction(dispatchQueue: dispatchQueue, isSync: isSync, writeHandler: { (realm) in
            realm.deleteAll()
        }) {
            completion?()
        }
    }
    
    func configuration() -> Realm.Configuration {
        var config = Realm.Configuration()
        config.schemaVersion = schemaVersion
        config.migrationBlock = migrationBlock
        config.deleteRealmIfMigrationNeeded = deleteRealmIfMigrationNeeded
        config.readOnly = readOnly
        config.encryptionKey = encryptionKey
        config.shouldCompactOnLaunch = shouldCompactOnLaunch
        config.syncConfiguration = syncConfiguration
        
        let file = "\(fileName).realm"
        if isUseInMemory {
            config.inMemoryIdentifier = "inMemory-\(file)"
        } else {
            if let appGroupIdentifier = appGroupIdentifier {
                config.fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)?.appendingPathComponent(file)
            } else {
                config.fileURL = URL(fileURLWithPath: RLMRealmPathForFile(file))
            }
            config.objectTypes = objectTypes
        }
        return config
    }
    
    func transaction(dispatchQueue: DispatchQueue = Self.defaultQueue, isSync: Bool = true, writeHandler: @escaping RealmWriteHandler, completion: (() -> Void)? = nil) {
        guard isSync else {
            dispatchQueue.async {
                self.perform(realm: try! Realm(configuration: self.configuration()), writeHandler: writeHandler, completion: completion)
            }
            return
        }
        
        dispatchQueue.sync {
            perform(realm: try! Realm(configuration: configuration()), writeHandler: writeHandler, completion: completion)
        }
    }
    
    // MARK: - Private methods
    
    private func perform(realm: Realm, writeHandler: @escaping RealmWriteHandler, completion: (() -> Void)? = nil) {
        do {
            try realm.write {
                writeHandler(realm)
            }
        } catch {
            print("RealmManager not write to database: \(error)")
        }
        
        if Thread.isMainThread {
            completion?()
        } else {
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
}
