FLUTTER="$HOME/git/flutter"
ARTIFACTS="$FLUTTER/bin/cache/artifacts"
artifacts=(
  "$ARTIFACTS/ideviceinstaller/ideviceinstaller"
  "$ARTIFACTS/ios-deploy/ios-deploy"
  "$ARTIFACTS/libimobiledevice/idevice_id"
  "$ARTIFACTS/libimobiledevice/ideviceinfo"
  "$ARTIFACTS/libimobiledevice/idevicename"
  "$ARTIFACTS/libimobiledevice/idevicescreenshot"
  "$ARTIFACTS/libimobiledevice/idevicesyslog"
  "$ARTIFACTS/libimobiledevice/libimobiledevice.6.dylib"
  "$ARTIFACTS/libplist/libplist.3.dylib"
  "$ARTIFACTS/openssl/libssl.1.0.0.dylib"
  "$ARTIFACTS/openssl/libcrypto.1.0.0.dylib"
  "$ARTIFACTS/usbmuxd/libusbmuxd.4.dylib"
)

for artifact in "${artifacts[@]}"; do
  codesign -vvv $artifact
  echo -e "$artifact\t$?"
done
