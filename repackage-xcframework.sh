#!/bin/bash
set -euo pipefail

# Repackage MatrixSDKFFI.xcframework to fix module discovery with Xcode 26.4 / Swift 6.3
# The issue: SPM passes -I Headers/ but the module.modulemap is at Headers/MatrixSDKFFI/module.modulemap
# The fix: flatten Headers/MatrixSDKFFI/* into Headers/ so -I Headers/ finds the modulemap directly

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ARTIFACTS_DIR="$SCRIPT_DIR/.build/artifacts/matrix-rust-components-swift/MatrixSDKFFI"
XCFRAMEWORK="$ARTIFACTS_DIR/MatrixSDKFFI.xcframework"
OUTPUT_ZIP="$SCRIPT_DIR/MatrixSDKFFI.xcframework.zip"

# Ensure the xcframework exists (run swift package resolve first)
if [ ! -d "$XCFRAMEWORK" ]; then
    echo "xcframework not found. Running swift package resolve..."
    cd "$SCRIPT_DIR"
    swift package resolve
fi

if [ ! -d "$XCFRAMEWORK" ]; then
    echo "ERROR: MatrixSDKFFI.xcframework not found at $XCFRAMEWORK"
    exit 1
fi

echo "Repackaging xcframework..."

SLICES=(
    "ios-arm64"
    "ios-arm64_x86_64-simulator"
    "macos-arm64_x86_64"
)

for slice in "${SLICES[@]}"; do
    HEADERS_DIR="$XCFRAMEWORK/$slice/Headers"
    NESTED_DIR="$HEADERS_DIR/MatrixSDKFFI"

    if [ ! -d "$NESTED_DIR" ]; then
        echo "WARNING: $NESTED_DIR not found, skipping slice $slice"
        continue
    fi

    echo "  Flattening $slice/Headers/MatrixSDKFFI/ -> $slice/Headers/"

    # Move all files from the nested MatrixSDKFFI/ directory up to Headers/
    mv "$NESTED_DIR"/* "$HEADERS_DIR/"

    # Remove the now-empty nested directory
    rmdir "$NESTED_DIR"
done

# Create the zip for distribution
echo "Creating zip archive..."
cd "$ARTIFACTS_DIR"
zip -r "$OUTPUT_ZIP" MatrixSDKFFI.xcframework

# Compute checksum for Package.swift
CHECKSUM=$(swift package compute-checksum "$OUTPUT_ZIP")
echo ""
echo "=== Done ==="
echo "Output: $OUTPUT_ZIP"
echo "Checksum: $CHECKSUM"
echo ""
echo "Next steps:"
echo "1. Create a GitHub release on your fork (e.g. tag '26.01.04-fixed')"
echo "2. Upload $OUTPUT_ZIP to the release"
echo "3. Update Package.swift with the new URL and checksum: $CHECKSUM"
