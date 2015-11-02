#!/bin/sh

XCPRETTY= #`which xcpretty`
BUILD_DIR=`pwd`/build

set -e

function test {
    echo "Running ALL iOS and OSX"

    set -x
    osascript -e 'tell app "iOS Simulator" to quit'
    xctool -workspace MobileDpt.xcworkspace\
      -scheme Tests test -test-sdk\
      iphonesimulator8.1\
      -destination "name=iPad Retina,OS=8.1"
    set +x
  }

  function clean {
  #rm -rf ~/Library/Developer/Xcode/DerivedData
  xctool -workspace MobileDpt.xcworkspace\
    -scheme Tests clean
}

function main {
if [ ! -z "$XCPRETTY" ]; then
  echo "XCPretty found. Use 'XCPRETTY= $0' if you want to disable."
fi

case "$1" in
  clean) clean ;;
*) test ;;
    esac
  }

main $@

