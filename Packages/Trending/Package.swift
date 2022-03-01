// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Trending",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Trending",
            targets: ["Trending"]),
    ],
    dependencies: [
        .package(name: "Core", path: "../Core"),
        .package(name: "MovieDetail", path: "../MovieDetail"),
        .package(url: "https://github.com/kean/NukeUI.git", from: "0.8.0")
    ],
    targets: [
        .target(
            name: "Trending",
            dependencies: ["Core", "MovieDetail", "NukeUI"]),
        .testTarget(
            name: "TrendingTests",
            dependencies: ["Trending"]),
    ]
)
