// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "swift-dependencies-tools",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "package-collection-generate", targets: ["PackageCollectionGenerator"]),
        .executable(name: "package-collection-sign", targets: ["PackageCollectionSigner"]),
        .executable(name: "package-collection-validate", targets: ["PackageCollectionValidator"]),
        .executable(name: "package-collection-diff", targets: ["PackageCollectionDiff"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.2")),
        .package(url: "https://github.com/apple/swift-package-manager.git", branch: "main"),
        .package(url: "https://github.com/swift-server/swift-backtrace.git", .upToNextMajor(from: "1.1.0")),
    ],
    targets: [
        .target(name: "Utilities",
                dependencies: [
                    .product(name: "SwiftPMPackageCollections", package: "swift-package-manager"),
                ]),

        .executableTarget(name: "PackageCollectionGenerator",
                          dependencies: [
                              "Utilities",
                              .product(name: "SwiftPMPackageCollections", package: "swift-package-manager"),
                              .product(name: "ArgumentParser", package: "swift-argument-parser"),
                              .product(name: "Backtrace", package: "swift-backtrace"),
                          ],
                          exclude: ["README.md"]),

        .executableTarget(name: "PackageCollectionSigner",
                          dependencies: [
                              "Utilities",
                              .product(name: "SwiftPMPackageCollections", package: "swift-package-manager"),
                              .product(name: "ArgumentParser", package: "swift-argument-parser"),
                              .product(name: "Backtrace", package: "swift-backtrace"),
                          ],
                          exclude: ["README.md"]),

        .executableTarget(name: "PackageCollectionValidator",
                          dependencies: [
                              "Utilities",
                              .product(name: "SwiftPMPackageCollections", package: "swift-package-manager"),
                              .product(name: "ArgumentParser", package: "swift-argument-parser"),
                              .product(name: "Backtrace", package: "swift-backtrace"),
                          ],
                          exclude: ["README.md"]),

        .executableTarget(name: "PackageCollectionDiff",
                          dependencies: [
                              "Utilities",
                              .product(name: "SwiftPMPackageCollections", package: "swift-package-manager"),
                              .product(name: "ArgumentParser", package: "swift-argument-parser"),
                              .product(name: "Backtrace", package: "swift-backtrace"),
                          ],
                          exclude: ["README.md"]),

        .target(name: "TestUtilities",
                dependencies: [
                    .product(name: "ArgumentParser", package: "swift-argument-parser"),
                    .product(name: "SwiftPMPackageCollections", package: "swift-package-manager"),
                ]),

        .testTarget(name: "UtilitiesTests",
                    dependencies: ["Utilities"]),

        .testTarget(name: "PackageCollectionGeneratorTests",
                    dependencies: ["PackageCollectionGenerator"],
                    exclude: ["Inputs"]),

        .testTarget(name: "PackageCollectionSignerTests",
                    dependencies: [
                        "PackageCollectionSigner",
                        "TestUtilities",
                    ],
                    exclude: ["Inputs"]),

        .testTarget(name: "PackageCollectionValidatorTests",
                    dependencies: [
                        "PackageCollectionValidator",
                        "TestUtilities",
                    ],
                    exclude: ["Inputs"]),

        .testTarget(name: "PackageCollectionDiffTests",
                    dependencies: [
                        "PackageCollectionDiff",
                        "TestUtilities",
                    ],
                    exclude: ["Inputs"]),
    ]
)
