// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Flint",
    products: [
        .executable(
            name: "flint",
            targets: ["Flint"]),
    ],
    dependencies: [
        .package(url: "https://github.com/flintbox/Bouncer", from: "0.1.2"),
        .package(url: "https://github.com/flintbox/Motor", from: "0.1.1"),
        .package(url: "https://github.com/flintbox/Work", from: "0.1.0"),
        .package(url: "https://github.com/flintbox/ANSIEscapeCode", from: "0.1.1"),
        .package(url: "https://github.com/jasonnam/PathFinder", .branch("develop")),
    ],
    targets: [
        .target(
            name: "Flint",
            dependencies: ["Bouncer", "Motor", "Work", "ANSIEscapeCode", "PathFinder"]),
    ]
)
