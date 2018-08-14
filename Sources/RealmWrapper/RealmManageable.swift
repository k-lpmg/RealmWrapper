import RealmSwift
import Realm.Private

public typealias RealmWriteHandler = (Realm) -> Void
public typealias RealmCompletionHandler = (Realm?, Error?) -> Void

public enum OrderingType {
    case ascending, descending
}

public protocol RealmManageable {
    
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
    
    // MARK: - Constructor
    
    init()
    
}

public extension RealmManageable {
    
    // MARK: - Constants
    
    static var defaultQueue: DispatchQueue {
        let label = "com.k-lpmg.RealmWrapper.RealmManageable.defaultQueue"
        return DispatchQueue(label: label)
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
    
    // MARK: - Public methods
    
    public func clear(writeQueue: DispatchQueue = Self.defaultQueue, isSync: Bool = true, completion: RealmCompletionHandler? = nil) {
        transaction(writeQueue: writeQueue, isSync: isSync, writeHandler: { (realm) in
            realm.deleteAll()
        }) { (realm, error) in
            completion?(realm, error)
        }
    }
    
    public func createConfiguration() -> Realm.Configuration {
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
    
    public func transaction(writeQueue: DispatchQueue = Self.defaultQueue, isSync: Bool = true, writeHandler: @escaping RealmWriteHandler, completionQueue: DispatchQueue = DispatchQueue.main, completion: RealmCompletionHandler? = nil) {
        guard isSync else {
            writeQueue.async {
                self.perform(writeHandler: writeHandler, completionQueue: completionQueue, completion: completion)
            }
            return
        }
        
        writeQueue.sync {
            perform(writeHandler: writeHandler, completionQueue: completionQueue, completion: completion)
        }
    }
    
    // MARK: - Private methods
    
    private func perform(writeHandler: @escaping RealmWriteHandler, completionQueue: DispatchQueue, completion: RealmCompletionHandler?) {
        let configuration = createConfiguration()
        let realm = try! Realm(configuration: configuration)
        do {
            try realm.write {
                writeHandler(realm)
            }
        } catch {
            print("RealmManager not write to database: \(error)")
        }
        
        Realm.asyncOpen(configuration: configuration, callbackQueue: completionQueue) { (realm, error) in
            realm?.refresh()
            completion?(realm, error)
        }
    }
    
}
