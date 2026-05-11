// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FeatureLaunch",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FeatureLaunch", targets: ["FeatureLaunch"]),
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
    ],
    targets: [
        .target(
            name: "FeatureLaunch",
            dependencies: ["DesignSystem"]
        ),
    ]
)
