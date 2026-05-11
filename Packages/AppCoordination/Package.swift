// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AppCoordination",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AppCoordination", targets: ["AppCoordination"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../DesignSystem"),
    ],
    targets: [
        .target(
            name: "AppCoordination",
            dependencies: ["Domain", "DesignSystem"]
        ),
    ]
)
