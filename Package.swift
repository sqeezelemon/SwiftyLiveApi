// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyLiveApi",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10)
    ],
    products: [
        .library(
            name: "SwiftyLiveApi",
            targets: ["SwiftyLiveApi"]),
    ],
    targets: [
        .target(
            name: "SwiftyLiveApi",
            dependencies: [],
            path: "Sources/SwiftyLiveApi"),
        .testTarget(
            name: "SwiftyLiveApiTests",
            dependencies: ["SwiftyLiveApi"],
            path: "Tests/SwiftyLiveApiTests",
            resources: [.process("apikey.txt")]),
    ]
)
