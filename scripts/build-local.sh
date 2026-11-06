#!/bin/bash
# Build a local development app without an Apple signing certificate.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_ROOT="$REPO_ROOT/build/local"
BUNDLE_ID="io.github.diabl0570.InputConfig"
APP="$BUILD_ROOT/InputConfig Local.app"

mkdir -p "$BUILD_ROOT"
xcodebuild \
  -project "$REPO_ROOT/InputConfig.xcodeproj" \
  -scheme InputConfig \
  -configuration Debug \
  -destination 'platform=macOS' \
  -derivedDataPath "$BUILD_ROOT/DerivedData" \
  CODE_SIGNING_ALLOWED=NO \
  DEVELOPMENT_TEAM= \
  PRODUCT_BUNDLE_IDENTIFIER="$BUNDLE_ID" \
  CLANG_MODULE_CACHE_PATH="$BUILD_ROOT/ModuleCache" \
  SWIFT_MODULE_CACHE_PATH="$BUILD_ROOT/ModuleCache" \
  COMPILATION_CACHE_ENABLE_CACHING=NO \
  build

if [ -d "$APP" ]; then
  rm -rf "$APP"
fi
ditto "$BUILD_ROOT/DerivedData/Build/Products/Debug/InputConfig.app" "$APP"
/usr/libexec/PlistBuddy -c 'Set :CFBundleDisplayName InputConfig Local' "$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Set :CFBundleName InputConfig Local' "$APP/Contents/Info.plist"

codesign --force --sign - \
  --identifier "$BUNDLE_ID.SteamControllerHelper" \
  --entitlements "$REPO_ROOT/SteamControllerHelper/SteamControllerHelper.entitlements" \
  "$APP/Contents/MacOS/SteamControllerHelper"
codesign --force --sign - \
  --entitlements "$REPO_ROOT/InputConfig/InputConfig.entitlements" \
  "$APP"
codesign --verify --deep --strict "$APP"
printf '\nBuilt and verified: %s\n' "$APP"
