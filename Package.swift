// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Fork of matrix-org/matrix-rust-components-swift with repackaged xcframework
// to fix module discovery with Xcode 26.4 / Swift 6.3.
// The original xcframework nests the module.modulemap inside Headers/MatrixSDKFFI/,
// which SPM's -I flag alone can no longer resolve. This fork flattens the headers
// so that -I Headers/ finds the modulemap directly.
import PackageDescription
let checksum = "6e39107a37cdd5906cc415a8b4a96428ab81fca727912dc1b37d91b8ce3c63fc"
let version = "26.04.07-state-events"
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
