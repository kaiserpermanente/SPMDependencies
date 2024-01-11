// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "SPMDependencies",
    platforms: [.macOS(.v12)],

    products: [
        .executable(name: "SPMDependencies", targets: ["SPMDependencies"]),
    ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.2")),
        .package(url: "https://github.com/apple/swift-package-manager.git", branch: "main")
    ],

    targets: [
        .target(
            name: "Utilities",
            dependencies: [.product(name: "SwiftPM", package: "swift-package-manager")]
        ),

        .executableTarget(
            name: "SPMDependencies",
            dependencies: [
                "Utilities",
                .product(name: "SwiftPM", package: "swift-package-manager"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),

        .target(
            name: "TestUtilities",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftPMPackageCollections", package: "swift-package-manager"),
            ]
        ),

        .testTarget(
            name: "UtilitiesTests",
            dependencies: ["Utilities"]
        ),

        .testTarget(
            name: "SPMDependenciesTests",
            dependencies: [
                "SPMDependencies",
                "TestUtilities"
            ]
        )
    ]
)
