#!/bin/sh

SCRIPT_DIR=`cd $(dirname $0); pwd`
TOOLS_DIR=$SCRIPT_DIR/tools

rm -rf $TOOLS_DIR/ios-deploy
cd $SCRIPT_DIR/ios-deploy
xcodebuild
mkdir $TOOLS_DIR/ios-deploy
cp -p build/Release/ios-deploy $TOOLS_DIR/ios-deploy/

rm -rf $TOOLS_DIR/android-platform-tools
cd $SCRIPT_DIR/android-platform-tools
if [ -r platform-tools-latest-darwin.zip ]; then
    curl_modified='-z platform-tools-latest-darwin.zip'
else
    curl_modified=''
fi
curl $curl_modified -OL https://dl.google.com/android/repository/platform-tools-latest-darwin.zip
unzip -o platform-tools-latest-darwin.zip 
cp -Rp platform-tools $TOOLS_DIR/android-platform-tools
