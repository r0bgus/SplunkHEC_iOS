// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SplunkHEC",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "SplunkHEC", targets: ["SplunkHEC"])
    ],
    targets: [
        .target(
            name: "SplunkHEC",
            path: "SplunkHEC",
            exclude: ["SplunkHEC.h"]
        ),
        .testTarget(
            name: "SplunkHECTests",
            dependencies: ["SplunkHEC"],
            path: "SplunkHECTests"
        )
    ]
)
