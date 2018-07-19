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
    static var queue: DispatchQueue { get }

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
    var realm: Realm { get }
    
    // MARK: - Methods
    
    func clear()
    func transaction(writeHandler: @escaping RealmWriteHandler)
    
}

public extension RealmManageable {
    static var queue: DispatchQueue {
        return DispatchQueue(label: "RealmManager")
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
    var realm: Realm {
        return try! Realm(configuration: configuration())
    }
    
    // MARK: - Internal methods
    
    func clear() {
        transaction { (realm) in
            realm.deleteAll()
        }
    }
    
    func transaction(writeHandler: @escaping RealmWriteHandler) {
        perform {
            do {
                try self.realm.write {
                    writeHandler(self.realm)
                }
            } catch {
                print("RealmManager not write to database: \(error)")
            }
        }
    }
    
    // MARK: - Private methods
    
    private func configuration() -> Realm.Configuration {
        var config = Realm.Configuration()
        config.schemaVersion = schemaVersion
        config.migrationBlock = migrationBlock
        config.deleteRealmIfMigrationNeeded = deleteRealmIfMigrationNeeded
        config.readOnly = readOnly
        config.encryptionKey = encryptionKey
        config.shouldCompactOnLaunch = shouldCompactOnLaunch
        config.syncConfiguration = syncConfiguration
        
        if isUseInMemory {
            config.inMemoryIdentifier = "inMemory-\(fileName)"
        } else {
            if let appGroupIdentifier = appGroupIdentifier {
                config.fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)?.appendingPathComponent(fileName)
            } else {
                config.fileURL = URL(fileURLWithPath: RLMRealmPathForFile("\(fileName).realm"))
            }
            config.objectTypes = objectTypes
        }
        return config
    }
    
    private func perform(execution: @escaping () -> Void) {
        if DispatchQueue.isCurrentQueue(queue: Self.queue) {
            execution()
        } else {
            Self.queue.sync {
                execution()
            }
        }
    }
    
}
