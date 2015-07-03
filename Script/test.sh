#!/bin/bash
# Script to compile and run unit tests from the command line

MAIN_TARGET="$1"

if [[ $MAIN_TARGET == '' ]]; then
  echo 'ERROR: Missing the required $MAIN_TARGET argument.';
  exit;
fi

echo "========================================================================="
echo "xctool -workspace ${MAIN_TARGET}.xcworkspace -scheme ${MAIN_TARGET} -sdk iphonesimulator clean test"
echo "========================================================================="

xctool -workspace ${MAIN_TARGET}.xcworkspace -scheme ${MAIN_TARGET} -sdk iphonesimulator clean test