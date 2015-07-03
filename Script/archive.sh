#!/bin/bash
# Script to compile and run unit tests from the command line

MAIN_TARGET="$1"
PROVISIONINGP_ROFILE="$2"

BUILD_DIR=$(pwd)/build
ARCHIVE_PATH=$BUILD_DIR/Archive/$MAIN_TARGET

if [[ $MAIN_TARGET == '' ]]; then
  echo 'ERROR: Missing the required $MAIN_TARGET argument.';
  exit;
fi

if [[ $PROVISIONINGP_ROFILE == '' ]]; then
  echo 'ERROR: Missing the required $PROVISIONINGP_ROFILE argument.';
  exit;
fi

echo "========================================================================="
echo "rm -rf ./build"
echo "========================================================================="

rm -rf $BUILD_DIR

echo "========================================================================="
echo "xctool -workspace $MAIN_TARGET.xcworkspace -scheme $MAIN_TARGET -sdk iphoneos clean archive -archivePath $ARCHIVE_PATH -derivedDataPath $BUILD_DIR"
echo "========================================================================="

xctool -workspace $MAIN_TARGET.xcworkspace -scheme $MAIN_TARGET -sdk iphoneos clean archive -archivePath $ARCHIVE_PATH -derivedDataPath $BUILD_DIR

echo "========================================================================="
echo "xcodebuild -exportArchive -archivePath $ARCHIVE_PATH.xcarchive -exportPath $ARCHIVE_PATH.ipa -exportFormat ipa -exportProvisioningProfile $PROVISIONINGP_ROFILE  | xcpretty"
echo "========================================================================="

xcodebuild -exportArchive -archivePath $ARCHIVE_PATH.xcarchive -exportPath $ARCHIVE_PATH.ipa -exportFormat ipa -exportProvisioningProfile $PROVISIONINGP_ROFILE  | xcpretty
