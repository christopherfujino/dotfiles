#!/bin/bash

names=(libimobiledevice libplist ios-deploy ideviceinstaller openssl usbmuxd)
LIB_PATH=''
for name in ${names[@]}; do
  LIB_PATH="$HOME/git/flutter/bin/cache/artifacts/$name:$LIB_PATH"
done

DYLD_LIBRARY_PATH=$LIB_PATH "$@"
