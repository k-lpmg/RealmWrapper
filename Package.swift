// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "RealmWrapper",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "RealmWrapper", targets: ["RealmWrapper"]),
    ],
    dependencies: [
      .package(name: "Realm", url: "https://github.com/realm/realm-cocoa", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "RealmWrapper",
            dependencies: [
                .product(name: "RealmSwift", package: "Realm"),
            ]
        ),
        .testTarget(
            name: "RealmWrapperTests",
            dependencies: ["RealmWrapper"],
            path: "./Tests"
        )
    ]
)
