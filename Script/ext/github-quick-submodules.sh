#!/bin/sh

# https://github.com/Quick/Quick  v0.6.0
# Merge pull request #270 from tibr/iOS7-support `ce729620fa9db8d3c76b69bbfc429cece97dbe36`
# https://github.com/Quick/Nimble v2.0.0
# Merge pull request #102 from marciok/iOS7-support `1088d5f70497f34be946e3e2829a10529f7bea8e`


SRCROOT=$(pwd)
EXTERNAL_DIR="Externals"

QUICK_PATH=$SRCROOT/$EXTERNAL_DIR/Quick
NIMBLE_PATH=$SRCROOT/$EXTERNAL_DIR/Nimble
OHHTTPSTUBS_PATH=$SRCROOT/$EXTERNAL_DIR/OHHTTPStubs

# Quick
cd $SRCROOT
if [[ ! -d $QUICK_PATH ]]; then
  git submodule add https://github.com/Quick/Quick.git $EXTERNAL_DIR/Quick
	cd $QUICK_PATH/Externals/Nimble
	git checkout v0.6.0
fi

# Nimble
cd $SRCROOT
if [[ ! -d $NIMBLE_PATH ]]; then
  git submodule add https://github.com/Quick/Nimble.git $EXTERNAL_DIR/Nimble
	cd $NIMBLE_PATH
	git checkout v2.0.0
fi

# OHHTTPStubs
cd $SRCROOT
if [[ ! -d $OHHTTPSTUBS_PATH ]]; then
  git submodule add https://github.com/github/OHHTTPStubs.git $EXTERNAL_DIR/OHHTTPStubs
fi
