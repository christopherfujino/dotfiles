#!/bin/bash

echo 'NOTE: This script is a work in progress!'

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

set -eo pipefail

function verifyStatus {
  OUTPUT=$(xcrun \
    altool \
    --notarization-info "$REQUEST_UUID" \
    -u "$CODESIGN_USERNAME" \
    --password "$APP_SPECIFIC_PASSWORD" \
    2>&1 )
  # With ERE could be /[ ]*Status: ([a-z ]+).*/
  STATUS=$(echo "$OUTPUT" | sed -n 's/[ ]*Status: \([a-z][a-z ]*\).*/\1/p')

  if [ "$STATUS" == 'success' ]; then
    echo "The notarization request for $REQUEST_UUID succeeded!"
    EXIT_CODE=0
  elif [ "$STATUS" == 'in progress' ]; then
    echo "The notarization request for $REQUEST_UUID is still pending..."
  else
    echo 'Uh oh, there was a problem!'
    EXIT_CODE=1
  fi
  echo
  echo "$OUTPUT"
  echo
}

function saveUuid {
  REQUEST_UUID=$(echo "$1" | sed -n 's/.*RequestUUID = \([a-z0-9-]*\).*/\1/p')
}

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

  local OUTPUT
  OUTPUT="$(xcrun altool \
    --notarize-app \
    --primary-bundle-id "$CODESIGN_PRIMARY_BUNDLE_ID" \
    --username "$CODESIGN_USERNAME" \
    --password "$APP_SPECIFIC_PASSWORD" \
    --file "$1" \
    2>&1 )"

  echo "$OUTPUT"
  echo

  saveUuid "$OUTPUT"

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
#verifySignature "$TARGET_PATH"
zipTarget "$TARGET_PATH"
notarize "$TARGET_ZIP"
#staple "$TARGET_PATH"
