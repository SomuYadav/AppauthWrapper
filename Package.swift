// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppauthWrapper",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppauthWrapper",
            targets: ["AppauthWrapper"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "AppAuth", url: "https://github.com/openid/AppAuth-iOS.git", from: "1.2.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AppauthWrapper",
            dependencies: [
                .product(name: "AppAuth", package: "AppAuth")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "AppauthWrapperTests",
            dependencies: ["AppauthWrapper"],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [.v4_2]
)
