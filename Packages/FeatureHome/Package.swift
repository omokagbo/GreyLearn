// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FeatureHome",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FeatureHome", targets: ["FeatureHome"]),
    ],
    dependencies: [
        .package(path: "../AppCoordination"),
        .package(path: "../Domain"),
        .package(path: "../DesignSystem"),
    ],
    targets: [
        .target(
            name: "FeatureHome",
            dependencies: ["AppCoordination", "Domain", "DesignSystem"]
        ),
    ]
)
