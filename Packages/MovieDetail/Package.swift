// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MovieDetail",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "MovieDetail",
            targets: ["MovieDetail"]),
    ],
    dependencies: [
        .package(name: "Core", path: "../Core"),
        .package(url: "https://github.com/kean/NukeUI.git", from: "0.8.0"),
        .package(name: "YouTubeiOSPlayerHelper", url: "https://github.com/youtube/youtube-ios-player-helper.git", from: "1.0.4")
    ],
    targets: [
        .target(
            name: "MovieDetail",
            dependencies: ["Core", "NukeUI", "YouTubeiOSPlayerHelper"]),
        .testTarget(
            name: "MovieDetailTests",
            dependencies: ["MovieDetail"]),
    ]
)
