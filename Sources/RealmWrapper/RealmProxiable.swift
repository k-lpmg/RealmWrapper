import Foundation

import RealmSwift

public enum QueryFilter {
    case string(String)
    case predicate(NSPredicate)
}

public protocol RealmProxiable {
    associatedtype RealmManager where RealmManager: RealmManageable
    var rm: RealmManager { get }
}

public extension RealmProxiable {
    
    var rm: RealmManager {
        return RealmManager()
    }

    func query<T: Object>(
        _ type: T.Type = T.self,
        filter: QueryFilter? = nil,
        sortProperty: String? = nil,
        ordering: OrderingType = .ascending
    ) -> RealmQuery<T> {
        guard let realm = try? Realm(configuration: rm.createConfiguration()) else {
            return RealmQuery(results: nil)
        }

        var results = realm.objects(type)
        if let filter = filter {
            switch filter {
            case let .string(stringValue):
                results = results.filter(stringValue)
            case let .predicate(predicateValue):
                results = results.filter(predicateValue)
            }
        }
        if let sortProperty = sortProperty {
            results = results.sorted(byKeyPath: sortProperty, ascending: ordering == .ascending)
        }

        return RealmQuery(results: results)
    }

}
