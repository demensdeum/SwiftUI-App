// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppUI",
    platforms: [.iOS(.v15), .tvOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppUI",
            targets: ["AppUI"]),
    ],
    dependencies: [
        .package(url: "./Modules/UITools", from: "1.0.0"),
        .package(url: "./Modules/Core", from: "1.0.0"),
        .package(url: "./Modules/Networking", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AppUI",
            dependencies: ["UITools","Core","Networking"],
            resources: [.process("KeiraOrPortman.mlmodelc")]
        ),
        .testTarget(
            name: "AppUITests",
            dependencies: ["AppUI"]),
    ]
)
