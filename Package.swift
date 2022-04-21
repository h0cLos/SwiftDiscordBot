// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftDiscordBot",
    dependencies: [
        .package(url: "https://github.com/norio-nomura/Sword", .branch("patch-for-swift-bot")),
        .package(url: "https://github.com/norio-nomura/SwiftBacktrace", from: "1.0.0"),
        .package(url: "https://github.com/jpsim/Yams", from: "3.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("5.1.3")),
    ],
    targets: [
        .target(
            name: "SwiftDiscordBot",
            dependencies: ["SwiftBacktrace", "Sword", "Yams", "RxSwift", "RxCocoa"]
        ),
    ]
)
