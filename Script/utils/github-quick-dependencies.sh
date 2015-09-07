#!/bin/sh

# https://github.com/Quick/Quick  v0.2.3
# Merge pull request #270 from tibr/iOS7-support `ce729620fa9db8d3c76b69bbfc429cece97dbe36`
# https://github.com/Quick/Nimble v0.3.1
# Merge pull request #102 from marciok/iOS7-support `1088d5f70497f34be946e3e2829a10529f7bea8e`


SRCROOT=$(pwd)
EXTERNAL_DIR="Externals"

QUICK_PATH=$SRCROOT/$EXTERNAL_DIR/Quick
NIMBLE_PATH=$SRCROOT/$EXTERNAL_DIR/Nimble
OHHTTPSTUBS_PATH=$SRCROOT/$EXTERNAL_DIR/OHHTTPStubs

# Quick
cd $SRCROOT
if [[ ! -d $QUICK_PATH ]]; then
  git clone https://github.com/Quick/Quick.git $EXTERNAL_DIR/Quick
fi
cd $QUICK_PATH
git checkout v0.3.1
rm -rf $QUICK_PATH/Externals/Nimble/.git
rm -rf $QUICK_PATH/.git

# Nimble
cd $SRCROOT
if [[ ! -d $NIMBLE_PATH ]]; then
  git clone https://github.com/Quick/Nimble.git $EXTERNAL_DIR/Nimble
fi
cd $NIMBLE_PATH
git checkout v0.4.2
rm -rf $NIMBLE_PATH/.git

# OHHTTPStubs
cd $SRCROOT
if [[ ! -d $OHHTTPSTUBS_PATH ]]; then
  git clone https://github.com/github/OHHTTPStubs.git $EXTERNAL_DIR/OHHTTPStubs
	rm -rf $OHHTTPSTUBS_PATH/.git
fi
