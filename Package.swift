// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Appetizer",
    products: [
        .executable(name: "appetizer", targets: ["AppetizerCL"]),
    ],
    dependencies: [
        // used for command line argument parsing
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.3.0"),
        
        // used to make NSColor from a hex string
        .package(url: "https://github.com/WilhelmOks/HexColor.git", from: "1.0.1")
    ],
    targets: [
        .target(
            name: "AppetizerCore",
            dependencies: []),
        .target(
            name: "AppetizerCL",
            dependencies: ["AppetizerCore", "SPMUtility", "HexNSColor"]),
        .testTarget(
            name: "AppetizerTests",
            dependencies: ["AppetizerCore"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
