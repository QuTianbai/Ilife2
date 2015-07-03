#! /bin/bash

mkdir Vendor
mkdir Classes
mkdir Assets
mkdir External
touch README.md

sh Script/git-quick-submodules.sh
cp Script/cocoapods-podfile Podfile
pod install --no-repo-update
