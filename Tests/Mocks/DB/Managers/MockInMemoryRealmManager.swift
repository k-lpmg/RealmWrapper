import RealmSwift
import RealmWrapper

final class MockInMemoryRealmManager: RealmManageable {
    
    var isUseInMemory: Bool {
        return true
    }
    var schemaVersion: UInt64 {
        return 1
    }
    var fileName: String {
        return "inMemory"
    }
    var objectTypes: [Object.Type]? {
        return [MockUser.self]
    }
    
}
