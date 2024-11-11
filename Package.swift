// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MonacaCapacitorPlugin",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "MonacaCapacitorPlugin",
            targets: ["MonacaCapacitorPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "MonacaCapacitorPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/MonacaCapacitorPlugin"),
        .testTarget(
            name: "MonacaCapacitorPluginTests",
            dependencies: ["MonacaCapacitorPlugin"],
            path: "ios/Tests/MonacaCapacitorPluginTests")
    ]
)
