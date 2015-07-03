#!/bin/bash
# Script to compile and run unit tests from the command line

MAIN_TARGET="$1"

BUILD_DIR=$(pwd)/build

if [[ $MAIN_TARGET == '' ]]; then
  echo 'ERROR: Missing the required $MAIN_TARGET argument.';
  exit;
fi

echo "========================================================================="
echo "rm -rf $BUILD_DIR"
echo "========================================================================="

rm -rf $BUILD_DIR

echo "========================================================================="
echo "xctool -workspace ${MAIN_TARGET}.xcworkspace -scheme ${MAIN_TARGET} -sdk iphonesimulator CONFIGURATION_BUILD_DIR=$BUILD_DIR clean build"
echo "========================================================================="

xctool -workspace ${MAIN_TARGET}.xcworkspace -scheme ${MAIN_TARGET} -sdk iphonesimulator CONFIGURATION_BUILD_DIR=$BUILD_DIR clean build 

echo "========================================================================="
echo "ios-sim launch build/${MAIN_TARGET}.app --devicetypeid 'com.apple.CoreSimulator.SimDeviceType.iPhone-6, 8.2' --exit" 
echo "========================================================================="

# ios-sim launch build/Example.app --devicetypeid 'com.apple.CoreSimulator.SimDeviceType.iPhone-6, 8.2'
ios-sim launch $BUILD_DIR/${MAIN_TARGET}.app --devicetypeid 'com.apple.CoreSimulator.SimDeviceType.iPhone-6, 8.2' --exit