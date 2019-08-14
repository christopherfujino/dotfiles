#!/bin/bash

if [ -z "$1" ]; then
  echo 'Please provide path to binary to sign as an argument.'
  exit 1
fi

TARGET_PATH="$1"

if [ -z "$APP_SPECIFIC_PASSWORD" ]; then
  echo "Please specify env variable \$APP_SPECIFIC_PASSWORD for authorization."
  exit 1
fi

if [ -z "$CODESIGN_USERNAME" ]; then
  echo "Please provide env variable \$CODESIGN_USERNAME. This should be the Apple Dev user who owns your certificate."
  exit 1
fi

if [ -z "$CODESIGN_CERT_NAME" ]; then
  echo "Please provide env variable \$CODESIGN_CERT_NAME. This only needs to be long enough to uniquely identify a single certificate among those in your keychain."
  exit 1
fi

CODESIGN_PRIMARY_BUNDLE_ID='com.flutter.experimental' # Arbitrary, for personal identification

set -euo pipefail

function verifyStatus {
  OUTPUT=$(xcrun altool --notarization-info "$REQUEST_UUID" -u "$CODESIGN_USERNAME" --password "$APP_SPECIFIC_PASSWORD")
  # With ERE could be /[ ]*Status: ([a-z ]+).*/
  STATUS=$(echo "$OUTPUT" | sed -n 's/[ ]*Status: \([a-z][a-z ]*\).*/\1/p')

  if [ "$STATUS" == 'success' ]; then
    echo "The notarization request for $REQUEST_UUID succeeded!"
    echo
    echo "$OUTPUT"
    EXIT_CODE=0
  elif [ "$STATUS" == 'in progress' ]; then
    echo "The notarization request for $REQUEST_UUID is still pending..."
  else
    echo 'Uh oh, there was a problem!'
    echo
    echo "$OUTPUT"
    EXIT_CODE=1
  fi
}

function saveUuid {
  REQUEST_UUID=$(echo "$1" | sed -n 's/^RequestUUID = \([a-z0-9-]*\)/\1/p')
  echo "Your RequestUUID is \"$REQUEST_UUID\""
  echo
}

STRING0="2019-08-13 12:56:18.932 altool[62341:349762] No errors uploading 'dart.zip'.
RequestUUID = f4416803-b274-4cfb-8d77-ef5432803588"

STRING1="2019-08-13 12:58:23.494 altool[62643:351373] No errors getting notarization info.

   RequestUUID: f4416803-b274-4cfb-8d77-ef5432803588
          Date: 2019-08-13 19:56:19 +0000
        Status: in progress
    LogFileURL: (null)"

STRING2="2019-08-13 12:58:52.037 altool[62662:351763] No errors getting notarization info.

   RequestUUID: f4416803-b274-4cfb-8d77-ef5432803588
          Date: 2019-08-13 19:56:19 +0000
        Status: success
    LogFileURL: https://osxapps-ssl.itunes.apple.com/itunes-assets/Enigma113/v4/65/f6/e9/65f6e917-a948-31de-438a-5b2e93814862/developer_log.json?accessKey=1565920731_2821058595715934222_4x3rADg4T2VgB%2BEzpGF%2BB%2FcadsLjY%2Boaz1Hflx%2Bd%2BuRjtk9pPpp3zv3BDrozFll%2BIQLbRDSxjLkvjPlxU5103UpKUCYjdQF5r9LaJG%2BgyPv36yFOMF0trEsAk%2Bl53X2mKoHOFVhKtQJnSP1Hi66W7c2mWamkFfl4iwgfT68BgP0%3D
   Status Code: 0
Status Message: Package Approved"

function sign {
  # force sign, add secure timestamp and hardened runtime
  codesign -f -s "$CODESIGN_CERT_NAME" "$1" --timestamp --options=runtime
  echo "Successfully signed $1"
  echo
}

function verifySignature {
  spctl -vvv --assess --type exec "$1"
  echo "Signature valid"
}

function zipTarget {
  TARGET_ZIP="$1.zip"
  zip "$TARGET_ZIP" "$1"
}

function notarize {
  echo 'Initiating notarization process...'
  echo

  saveUuid "$(xcrun altool --notarize-app --primary-bundle-id "$CODESIGN_PRIMARY_BUNDLE_ID" --username "$CODESIGN_USERNAME" --password "$APP_SPECIFIC_PASSWORD" --file "$1")"

  time pollForStatus
  if [ $EXIT_CODE == 1 ]; then
    exit 1
  fi
}

function pollForStatus {
  while [ -z $EXIT_CODE ]; do
    TIMEOUT=20
    echo "Waiting $TIMEOUT seconds until we check status..."
    echo
    sleep $TIMEOUT
    verifyStatus
  done
}

function staple {
  xcrun stapler staple -v "$1"
}

sign "$TARGET_PATH"
verifySignature "$TARGET_PATH"
zipTarget "$TARGET_PATH"
notarize "$TARGET_ZIP"
#staple "$TARGET_PATH"

#saveUuid "$STRING0"
#
#verifyStatus "$STRING1"
#verifyStatus "$STRING2"
