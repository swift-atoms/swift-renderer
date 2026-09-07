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

        .library(name: "Renderer Foundation Integration", targets: ["Renderer Foundation Integration"]),
        .library(name: "Renderer Test Support", targets: ["Renderer Test Support"]),
    ],
    targets: [
        .target(
            name: "Renderer",
            path: "Sources/Renderer"
        ),
        
        .target(
            name: "Renderer Foundation Integration",
            dependencies: [
                .target(name: "Renderer"),
            ],
            path: "Sources/Renderer Foundation Integration"
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
                .target(name: "Renderer Foundation Integration"),
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
