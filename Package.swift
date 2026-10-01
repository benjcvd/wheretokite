// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "WhereToKite",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "KiteCore", targets: ["KiteCore"]),
        .executable(name: "kite", targets: ["kite"]),
    ],
    targets: [
        // Platform-independent engine, shared by the CLI prototype and the future iOS app.
        .target(name: "KiteCore"),
        .executableTarget(name: "kite", dependencies: ["KiteCore"]),
        .testTarget(name: "KiteCoreTests", dependencies: ["KiteCore"]),
    ]
)
