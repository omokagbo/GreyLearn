// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FeatureLogin",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FeatureLogin", targets: ["FeatureLogin"]),
    ],
    dependencies: [
        .package(path: "../AppCoordination"),
        .package(path: "../Domain"),
        .package(path: "../DesignSystem"),
    ],
    targets: [
        .target(
            name: "FeatureLogin",
            dependencies: ["AppCoordination", "Domain", "DesignSystem"]
        ),
    ]
)
