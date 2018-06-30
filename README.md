# RealmWrapper 

![Swift](https://img.shields.io/badge/Swift-4.1-orange.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://raw.githubusercontent.com/k-lpmg/RealmWrapper/master/LICENSE) [![Cocoapods](https://img.shields.io/cocoapods/v/RealmWrapper.svg?style=flat)](https://cocoapods.org/pods/RealmWrapper)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

RealmWrapper is wrapper library for [RealmSwift](https://github.com/realm/realm-cocoa/tree/master/RealmSwift) in [realm-cocoa](https://github.com/realm/realm-cocoa)

If you use [RealmWrapper](https://github.com/k-lpmg/RealmWrapper), you can easily use UI update through Notification and Transaction processing.
Also, you do not have to worry about the retain cycle when using self in the Notification block.

- [Comparison](#comparison)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)


## Comparison

If you use [RealmSwift](https://github.com/realm/realm-cocoa/tree/master/RealmSwift), you have to be careful about try statement and thread processing every transaction.
However, In [RealmManageable](https://github.com/k-lpmg/RealmWrapper/blob/master/Sources/RealmManageable.swift) which manages one realm file, transaction processing is performed using Realm-only DispatchQueue.
[RealmProxiable](https://github.com/k-lpmg/RealmWrapper/blob/master/Sources/RealmProxiable.swift), which owns [RealmManageable](https://github.com/k-lpmg/RealmWrapper/blob/master/Sources/RealmManageable.swift), can easily add, modify or delete models without having to worry about try statement and thread processing.

> User Model
```swift
@objcMembers
class User: Object {
    dynamic var id: String?
    dynamic var name: String?

    override static func primaryKey() -> String? {
        return "id"
    }
}
```

> Using RealmWrapper
```swift
var user = User()
user.id = UUID().uuidString
user.name = "Kevin"

UserRealmProxy().append(user)
```

> Using RealmSwift
```swift
var user = User()
user.id = UUID().uuidString
user.name = "Kevin"

let realm = try! Realm(configuration: Realm.Configuration(fileURL: URL(fileURLWithPath: RLMRealmPathForFile("user.realm")), schemaVersion: 1, objectTypes: [User.self]))
try! realm.write {
    realm.add(user)
}
```


## Getting Started

1. Create a `RealmManager` that manages one realm file.

```swift
final class UserRealmManager: RealmManageable {

    static var shared: UserRealmManager = UserRealmManager()

    var isUseInMemory: Bool {
        return false
    }
    var schemaVersion: UInt64 {
        return 1
    }
    var fileName: String {
        return "user"
    }
    var objectTypes: [Object.Type]? {
        return [User.self]
    }

}
```

2. Create a `RealmProxy` that is responsible for the CRUD function to be accessed by the Controller.

```swift
struct UserRealmProxy<RealmManager: UserRealmManager>: RealmProxiable {

    var users: RealmQuery<User> {
        return query(sortProperty: "name", ordering: .ascending)
    }

    func append(_ user: User) {
        transaction { (realm) in
            realm.add(user, update: true)
        }
    }

    func delete(_ user: User) {
        transaction { (realm) in
            realm.delete(user)
        }   
    }

    func updateName(id: String, name: String) {
        guard let user = userFromId(id) else {return}
        transaction { (realm) in
            user.name = name
            realm.add(user, update: true)
        }
    }

    func userFromId(_ id: String) -> User? {
        return query(filter: "id == '\(id)'").results.first
    }

}

var user = User()
user.id = UUID().uuidString
user.name = "Kevin"

UserRealmProxy().append(user)
UserRealmProxy().delete(user)
UserRealmProxy().updateName(id: user.id, name: "Kris")
```

3. If you want to register the notification of the status of the Realm object in the controller, you can register the notification in [RealmQuery](https://github.com/k-lpmg/RealmWrapper/blob/master/Sources/RealmQuery.swift).

```swift
let users: RealmQuery<User> = UserRealmProxy().users

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

}
```

Also, since [RealmQuery](https://github.com/k-lpmg/RealmWrapper/blob/master/Sources/RealmQuery.swift) is doing weak handling to prevent the retain cycle, you can use closures without worrying about the retain cycle if you pass only self.

```swift

public func addDeleteNotificationBlock<Object: AnyObject>(_ object: Object, block: @escaping (Object, [IndexPath]) -> Void) -> Self {
    deleteNotificationBlock = { [weak object] (insertions) in
        guard let weakObject = object else {return}

        block(weakObject, insertions)
    }
    
    return self
}
```


## Usage

#### RealmManageable Property

| Property | Type | Default | Description |
| -------- | ---- | ------- | ---------- |
| `isUseInMemory` | `Bool` | `required` |`Use InMemory Realm` |
| `appGroupIdentifier` | `String?` | `nil` |`Value for Realm file directory for App Extension`|
| `objectTypes` | `[Object.Type]?` | `nil` |`Type of Realm object used in realm file`|
| `migrationBlock` | `String` | `nil` |`Migration Block`|


## Installation

### CocoaPods (iOS 8+)

You can use [CocoaPods](http://cocoapods.org/) to install `RealmWrapper` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
pod 'RealmWrapper'
end
```

### Carthage (iOS 8+)

Cartfile
```ruby
github "k-lpmg/RealmWrapper"
```


## LICENSE

These works are available under the MIT license. See the [LICENSE][license] file
for more info.

[license]: LICENSE
