// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "SwiftNewtype",
    platforms: [.macOS(.v10_15), .iOS(.v13), .macCatalyst(.v13), .tvOS(.v13), .visionOS(.v1), .watchOS(.v6)],
    products: [
        .library(
            name: "SwiftNewtype",
            targets: ["SwiftNewtype"]
        ),
        .executable(
            name: "SwiftNewtypeClient",
            targets: ["SwiftNewtypeClient"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", .upToNextMajor(from: "510.0.2"))
    ],
    targets: [
        .macro(
            name: "SwiftNewtypeMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "SwiftNewtype", dependencies: ["SwiftNewtypeMacros"]),
        .executableTarget(name: "SwiftNewtypeClient", dependencies: ["SwiftNewtype"]),
        .testTarget(
            name: "SwiftNewtypeTests",
            dependencies: [
                "SwiftNewtypeMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ]
        )
    ]
)
