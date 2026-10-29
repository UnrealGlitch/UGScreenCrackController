// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

internal let kPackage = Package(
    name: "UGScreenCrackController",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "UGScreenCrackController",
            targets: ["UGScreenCrackController"]
        )
    ],
    targets: [
        .target(
            name: "UGScreenCrackController",
            path: "Sources"
        )
    ],
    swiftLanguageModes: [.v5]
)
