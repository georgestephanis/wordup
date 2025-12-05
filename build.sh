#!/usr/bin/env bash
# Build script for WordUp macOS app
# This script must be run on macOS with Xcode installed

set -e

echo "🚀 Building WordUp..."

# Check if running on macOS
if [ "$(uname)" != "Darwin" ]; then
    echo "❌ Error: This script must be run on macOS"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed"
    exit 1
fi

# Build the app
echo "📦 Compiling with Swift Package Manager..."
swift build -c release

# If we reach here, build succeeded (set -e would have exited on error)
echo "✅ Build successful!"
echo "📍 Binary location: .build/release/WordUp"
echo ""
echo "To run the app:"
echo "  .build/release/WordUp"
