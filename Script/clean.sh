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

rm -rf .$BUILD_DIR

echo "========================================================================="
echo "xctool -workspace ${MAIN_TARGET}.xcworkspace -scheme ${MAIN_TARGET} clean"
echo "========================================================================="

xctool -workspace ${MAIN_TARGET}.xcworkspace -scheme ${MAIN_TARGET} clean

echo 'DerivedData Cleaning...'

rm -rf ~/Library/Developer/Xcode/DerivedData/*

echo 'Done'
ls -l ~/Library/Developer/Xcode/DerivedData
