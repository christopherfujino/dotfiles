#!/bin/bash

set -euo pipefail

BREW='brew'

#rm -rf $($BREW --cellar)
#rm -rf $($BREW --cache)

# libimobiledevice
$BREW update
$BREW install --HEAD usbmuxd
$BREW link usbmuxd
$BREW install --HEAD libimobiledevice
$BREW install ideviceinstaller

# ios-deploy
$BREW install ios-deploy

# Cocoapods
$BREW install cocoapods
pod setup
