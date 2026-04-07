// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Fork of matrix-org/matrix-rust-components-swift with repackaged xcframework
// to fix module discovery with Xcode 26.4 / Swift 6.3.
// The original xcframework nests the module.modulemap inside Headers/MatrixSDKFFI/,
// which SPM's -I flag alone can no longer resolve. This fork flattens the headers
// so that -I Headers/ finds the modulemap directly.
import PackageDescription
let checksum = "88c43b2247c7ed4ca90abf8f777ba2c1d15c532cfe10fc8f9c53c7495ffee6d5"
let version = "26.04.07-account-data"
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
