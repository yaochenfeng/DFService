// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DFService",
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v8)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DFService",
            targets: ["DFService"]),
        .library(
            name: "DFService-Dynamic",
            type: .dynamic,
            targets: ["DFService"]),
    ],
    dependencies: [
//       .package(url: "https://github.com/apple/swift-log", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DFService",
            resources: [
                .process("Resources/Assets.xcassets")
            ]
        ),
        .testTarget(
            name: "DFServiceTests",
            dependencies: ["DFService"]),
    ]
)
