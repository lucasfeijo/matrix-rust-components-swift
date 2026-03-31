// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Fork of matrix-org/matrix-rust-components-swift with repackaged xcframework
// to fix module discovery with Xcode 26.4 / Swift 6.3.
// The original xcframework nests the module.modulemap inside Headers/MatrixSDKFFI/,
// which SPM's -I flag alone can no longer resolve. This fork flattens the headers
// so that -I Headers/ finds the modulemap directly.
import PackageDescription
let checksum = "92370f71e4328b657474ccc6c1e39d0d01f9de1376a3e21bd92732ff7ee5d0ea"
let version = "26.01.04-fixed"
let url = "https://github.com/lucasfeijo/matrix-rust-components-swift/releases/download/\(version)/MatrixSDKFFI.xcframework.zip"
let package = Package(
    name: "MatrixRustSDK",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "MatrixRustSDK", targets: ["MatrixRustSDK"]),
    ],
    targets: [
        .binaryTarget(name: "MatrixSDKFFI", url: url, checksum: checksum),
        .target(name: "MatrixRustSDK", dependencies: [.target(name: "MatrixSDKFFI")])
    ]
)
