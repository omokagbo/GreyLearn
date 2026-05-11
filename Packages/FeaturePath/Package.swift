// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FeaturePath",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FeaturePath", targets: ["FeaturePath"]),
    ],
    dependencies: [
        .package(path: "../AppCoordination"),
        .package(path: "../Domain"),
        .package(path: "../DesignSystem"),
    ],
    targets: [
        .target(
            name: "FeaturePath",
            dependencies: ["AppCoordination", "Domain", "DesignSystem"]
        ),
    ]
)
