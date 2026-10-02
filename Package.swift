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
        .library(name: "Empty Renderer Test Support", targets: ["Empty Renderer Test Support"]),
        .library(name: "Pair Renderer Test Support", targets: ["Pair Renderer Test Support"]),
        .library(name: "Renderer Document Test Support", targets: ["Renderer Document Test Support"]),
    ],
    traits: [
        .trait(name: "Document", description: "Absorbed Document integration"),
        .trait(name: "Empty", description: "Absorbed Empty integration"),
        .trait(name: "Pair", description: "Absorbed Pair integration"),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-empty.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-pair.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Renderer",
            dependencies: [
                .product(name: "Empty", package: "swift-empty", condition: .when(traits: ["Empty"])),
                .product(name: "Pair", package: "swift-pair", condition: .when(traits: ["Pair"])),
    ],
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
        .testTarget(name: "Absorbed swift-empty-renderer Empty Renderer Tests", dependencies: [.target(name: "Renderer")], path: "Tests/Absorbed/swift-empty-renderer/Empty Renderer Tests"),
        .target(name: "Empty Renderer Test Support", dependencies: [.target(name: "Renderer")], path: "Tests/Absorbed/swift-empty-renderer/Support"),
        .testTarget(name: "Absorbed swift-pair-renderer Pair Renderer Tests", dependencies: [.target(name: "Renderer")], path: "Tests/Absorbed/swift-pair-renderer/Pair Renderer Tests"),
        .target(name: "Pair Renderer Test Support", dependencies: [.target(name: "Renderer")], path: "Tests/Absorbed/swift-pair-renderer/Support"),
        .testTarget(name: "Absorbed swift-renderer-document Renderer Document Tests", dependencies: [.target(name: "Renderer"), .target(name: "Renderer Document Test Support")], path: "Tests/Absorbed/swift-renderer-document/Renderer Document Tests"),
        .target(name: "Renderer Document Test Support", dependencies: [.target(name: "Renderer")], path: "Tests/Absorbed/swift-renderer-document/Support"),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
        .treatAllWarnings(as: .error),
    ]
}
