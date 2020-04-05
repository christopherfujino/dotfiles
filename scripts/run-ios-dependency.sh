#!/bin/bash

names=(libimobiledevice libplist ios-deploy ideviceinstaller openssl usbmuxd)
FLUTTER_PATH="$HOME/git/flutter"
LIB_PATH=''
for name in "${names[@]}"; do
  LIB_PATH="$FLUTTER_PATH/bin/cache/artifacts/$name:$LIB_PATH"
done

DYLD_LIBRARY_PATH=$LIB_PATH "$@"
