// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Router",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Router",
            targets: ["Router", "DeepLink"]),
    ],
    dependencies: [
        .package(
          url: "https://github.com/firebase/firebase-ios-sdk.git",
          .upToNextMajor(from: "10.4.0")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Router",
            dependencies: [
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfigSwift", package: "firebase-ios-sdk"),
            ],
            resources: [.process("Resources")]),
        .testTarget(
            name: "RouterTests",
            dependencies: ["Router"]),
        .target(
            name: "DeepLink",
            dependencies: ["Router"]),
        .testTarget(
            name: "DeepLinkTests",
            dependencies: ["DeepLink"]),
    ]
)
