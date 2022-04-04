#!/bin/bash
WORKSPACE=$PWD
NOW=$(date +"%m%d_%H%M")
#NOW="9999_9999"
PROD_NAME="Argon2ObjC"
ARCHIVE_PATH_MACOS="archives/$PROD_NAME-macOS"
ARCHIVE_PATH_SIMU="archives/$PROD_NAME-Simulator"
ARCHIVE_PATH_IOS="archives/$PROD_NAME-iOS"

# Specify the version number
VERSION_NUMBER=1.0.0
BUILD_NUMBER=1
# Version
CMD="agvtool new-version $BUILD_NUMBER"
echo "[XCFramework] $CMD"
$CMD
CMD="agvtool new-marketing-version $VERSION_NUMBER"
echo "[XCFramework] $CMD"
$CMD

# XC Framework output path
XCFRAMEWORK_OUTPUT="ZZ.Release/v$VERSION_NUMBER-$NOW/$PROD_NAME.xcframework"

# ----------------
echo "[XCFramework] Start"
 
# Build macOS Framework
echo "[XCFramework] Build macOS Framework"
xcodebuild archive \
 -project "$PROD_NAME.xcodeproj" \
 -scheme "$PROD_NAME-macOS" \
 -configuration Release \
 -archivePath "$ARCHIVE_PATH_MACOS" \
 SKIP_INSTALL=NO \
 BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
 clean build || exit 1
 

# Build ios-simulator Framework
echo "[XCFramework] Build iOS Simulator Framework"
xcodebuild archive \
 -project "$PROD_NAME.xcodeproj" \
 -scheme "$PROD_NAME" \
 -configuration Release \
 -sdk iphonesimulator \
 -archivePath "$ARCHIVE_PATH_SIMU" \
 VALID_ARCHS="arm64 x86_64" \
 SKIP_INSTALL=NO \
 BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
 clean build || exit 1

# Build ios-arm64 Framework
echo "[XCFramework] Build ios-arm64 Framework"
xcodebuild archive \
 -project "$PROD_NAME.xcodeproj" \
 -scheme "$PROD_NAME" \
 -configuration Release \
 -sdk iphoneos \
 -archivePath "$ARCHIVE_PATH_IOS" \
 SKIP_INSTALL=NO \
 BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
 clean build || exit 1

# Create XCframework
echo "[XCFramework] Create XCframework"
xcodebuild -create-xcframework \
           -framework "$ARCHIVE_PATH_MACOS.xcarchive/Products/Library/Frameworks/${PROD_NAME}_macOS.framework" \
           -framework "$ARCHIVE_PATH_IOS.xcarchive/Products/Library/Frameworks/$PROD_NAME.framework" \
           -framework "$ARCHIVE_PATH_SIMU.xcarchive/Products/Library/Frameworks/$PROD_NAME.framework" \
           -output "$XCFRAMEWORK_OUTPUT"

# Delete 'archives' folder
rm -rf "$WORKSPACE/archives"

# Compress xcframework
echo "[XCFramework] Compress xcframework"
cd $WORKSPACE/ZZ.Release/v$VERSION_NUMBER-$NOW
zip -vry $PROD_NAME.xcframework.zip $PROD_NAME.xcframework/ -x "*.DS_Store"

# Compute checksum
swift package compute-checksum $PROD_NAME.xcframework.zip
