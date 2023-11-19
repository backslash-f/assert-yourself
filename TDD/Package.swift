// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "TDD",
    products: [
        .library(
            name: "TDD",
            targets: ["TDD"]
        )
    ],
    targets: [
        .target(
            name: "TDD"),
        .testTarget(
            name: "TDDTests",
            dependencies: ["TDD"]
        )
    ]
)
