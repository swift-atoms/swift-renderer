// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-renderer",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Renderer", targets: ["Renderer"]),
        .library(name: "Renderer Standard Library Integration", targets: ["Renderer Standard Library Integration"]),
        .library(name: "Renderer Foundation Library Integration", targets: ["Renderer Foundation Library Integration"]),
        .library(name: "Renderer Test Support", targets: ["Renderer Test Support"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-pair.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Renderer",
            dependencies: [
                .product(name: "Pair", package: "swift-pair"),
            ],
            path: "Sources/Renderer"
        ),
        .target(
            name: "Renderer Standard Library Integration",
            dependencies: [
                .target(name: "Renderer"),
            ],
            path: "Sources/Renderer Standard Library Integration"
        ),
        .target(
            name: "Renderer Foundation Library Integration",
            dependencies: [
                .target(name: "Renderer"),
                .target(name: "Renderer Standard Library Integration"),
            ],
            path: "Sources/Renderer Foundation Library Integration"
        ),
        .target(
            name: "Renderer Test Support",
            dependencies: [
                .target(name: "Renderer"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Renderer Tests",
            dependencies: [
                .target(name: "Renderer"),
                .target(name: "Renderer Test Support"),
                .target(name: "Renderer Standard Library Integration"),
                .target(name: "Renderer Foundation Library Integration"),
            ],
            path: "Tests/Renderer Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
