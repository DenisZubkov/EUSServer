// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "EUSServer",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMinor(from: "3.3.0")),
        .package(url: "https://github.com/vapor/fluent-sqlite.git", .upToNextMinor(from: "3.0.0")),
        .package(url: "https://github.com/vapor/fluent-mysql.git", .upToNextMinor(from: "3.0.0")),
        .Package(url: "https://github.com/vapor/engine.git", majorVersion: 2)
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentSQLite", "FluentMySQL", "HTTP"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
    ]
)

