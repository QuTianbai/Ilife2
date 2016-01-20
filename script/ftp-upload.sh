#!/bin/bash
# Script to upload ipa file to server

find_pattern () {
    ls -d $1 2>/dev/null | head -n 1
}

BUILD_DIR=$(pwd)/build
BUILD_VERSION=`cat VERSION`

XCWORKSPACE=$(find_pattern "*.xcworkspace")
XCODEPROJ=$(find_pattern "*.xcodeproj")

if [[ $XCWORKSPACE == '' ]]; then
	SCHEME=`echo $XCODEPROJ | awk -F '.xcodeproj' '{print $1}'`
	DIR=`date +%Y%m%d`
	cd $BUILD_DIR/Archive/
	ftp -in -u ftp://jie.yang:1234qwer@192.168.2.47/APP/ios/$DIR/ $SCHEME-$BUILD_VERSION.ipa
else
	SCHEME=`echo $XCWORKSPACE | awk -F '.xcworkspace' '{print $1}'`
	DIR=`date +%Y%m%d`
	cd $BUILD_DIR/Archive/
	ftp -in -u ftp://jie.yang:1234qwer@192.168.2.47/APP/ios/$DIR/ $SCHEME-$BUILD_VERSION.ipa
fi

