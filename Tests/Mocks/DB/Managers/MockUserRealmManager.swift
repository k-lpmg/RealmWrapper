import RealmSwift
import RealmWrapper

final class MockUserRealmManager: RealmManageable {
    
    var isUseInMemory: Bool {
        return false
    }
    var schemaVersion: UInt64 {
        return 1
    }
    var fileName: String {
        return "mock-user"
    }
    var objectTypes: [Object.Type]? {
        return [MockUser.self]
    }
    
}
