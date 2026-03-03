// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "ShakerLog",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ShakerLog",
            targets: ["ShakerLog"]
        ),
    ],
    targets: [
        .target(
            name: "ShakerLog"
        ),
        .testTarget(
            name: "ShakerLogTests",
            dependencies: ["ShakerLog"]
        ),
    ]
)
