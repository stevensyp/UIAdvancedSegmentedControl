// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIAdvancedSegmentedControl",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "UIAdvancedSegmentedControl",
            targets: ["UIAdvancedSegmentedControl"]),
    ],
    targets: [
        .target(
            name: "UIAdvancedSegmentedControl",
            dependencies: [],
            path: "./UIAdvancedSegmentedControl")
    ]
)
