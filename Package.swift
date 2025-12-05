// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "WordUp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "WordUp",
            targets: ["WordUp"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "WordUp",
            dependencies: [],
            path: "Sources",
            resources: [
                .process("Info.plist")
            ]
        )
    ]
)
