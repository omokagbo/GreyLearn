// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FeatureChat",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FeatureChat", targets: ["FeatureChat"]),
    ],
    dependencies: [
        .package(path: "../AppCoordination"),
        .package(path: "../Domain"),
        .package(path: "../DesignSystem"),
    ],
    targets: [
        .target(
            name: "FeatureChat",
            dependencies: ["AppCoordination", "Domain", "DesignSystem"]
        ),
    ]
)
