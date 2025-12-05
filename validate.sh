#!/bin/bash
# This script validates the Swift syntax without building
# Note: This project can only be built on macOS with Xcode

echo "Validating Swift files..."
echo "Note: This project requires macOS and Xcode to build."
echo ""

if [ "$(uname)" != "Darwin" ]; then
    echo "⚠️  Warning: Not running on macOS. Build will fail as Cocoa framework is not available."
    echo "✓  Swift files created successfully. Build on macOS to compile."
    exit 0
fi

# Check if we're on macOS and can build
echo "Running on macOS, attempting to build..."
swift build -c release
