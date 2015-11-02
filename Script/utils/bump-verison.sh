#!/bin/bash

# This only work with project.xcworkspace

# works with a file called VERSION in the current directory,
# the contents of which should be a semantic version number
# such as "1.2.3"

# this script will display the current version, automatically
# suggest a "minor" version update, and ask for input to use
# the suggestion, or a newly entered value.

# once the new version number is determined, the script will
# pull a list of changes from git history, prepend this to
# a file called CHANGES (under the title of the new version
# number) and create a GIT tag.

find_pattern () {
    ls -d $1 2>/dev/null | head -n 1
}

XCWORKSPACE=$(find_pattern "*.xcworkspace")
SCHEME=`echo $XCWORKSPACE | awk -F '.xcworkspace' '{print $1}'`
SCHEME_PLIST=$SCHEME/info.plist

update_xcode_version() {
    if [[ ! -n "$1" ]]; then
        #statements
        exit
    fi

    if [[ -f "$SCHEME_PLIST" ]]; then
        NEWSUBVERSION=$1
        # Updated version
        /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $NEWSUBVERSION" "$SCHEME_PLIST"
        # Log New Version
        VERSIONNUM=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$SCHEME_PLIST")
        echo [$SCHEME] bumped verion to $VERSIONNUM
        #statements
    fi
}

if [ -f VERSION ]; then
    BASE_STRING=`cat VERSION`
    BASE_LIST=(`echo $BASE_STRING | tr '.' ' '`)
    V_MAJOR=${BASE_LIST[0]}
    V_MINOR=${BASE_LIST[1]}
    V_PATCH=${BASE_LIST[2]}
    echo "Current version : $BASE_STRING"
    V_MINOR=$((V_MINOR + 1))
    V_PATCH=0
    SUGGESTED_VERSION="$V_MAJOR.$V_MINOR.$V_PATCH"
    read -p "Enter a version number [$SUGGESTED_VERSION]: " INPUT_STRING
    if [ "$INPUT_STRING" = "" ]; then
        INPUT_STRING=$SUGGESTED_VERSION
    fi
    echo "Will set new version to be $INPUT_STRING"
    echo $INPUT_STRING > VERSION
    echo "Version $INPUT_STRING:" > tmpfile
    git log --pretty=format:" - %s" "v$BASE_STRING"...HEAD >> tmpfile
    echo "" >> tmpfile
    echo "" >> tmpfile
    cat CHANGES >> tmpfile
    mv tmpfile CHANGES

    # Update xcode info.plist build verson
    update_xcode_version $INPUT_STRING

    # todo
    # git add VERSION CHANGES $SCHEME_PLIST
    git add .
    git commit -m "Bumping version to $INPUT_STRING"
    git tag -a -m "Tagging version $INPUT_STRING" "v$INPUT_STRING"
    # git push origin --tags
else
    echo "Could not find a VERSION file"
    read -p "Do you want to create a version file and start from scratch? [y]" RESPONSE
    if [ "$RESPONSE" = "" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "Y" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "Yes" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "yes" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "YES" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "y" ]; then
        echo "0.1.0" > VERSION
        echo "Version 0.1.0" > CHANGES
        git log --pretty=format:" - %s" >> CHANGES
        echo "" >> CHANGES
        echo "" >> CHANGES

        # Update xcode info.plist build verson
        update_xcode_version 0.1.0

        # todo
        # git add VERSION CHANGES $SCHEME_PLIST
        git add .
        git commit -m "Added VERSION and CHANGES files, Bumping version to v0.1.0"
        git tag -a -m "Tagging version 0.1.0" "v0.1.0"
        # git push origin --tags
    fi

fi