// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "JamfKiller",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "JamfKiller", targets: ["JamfKiller"])
    ],
    targets: [
        .executableTarget(
            name: "JamfKiller",
            dependencies: []
        )
    ]
) 