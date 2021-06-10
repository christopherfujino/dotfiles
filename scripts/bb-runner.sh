#!/usr/bin/env bash

set -euo pipefail

# oneof 'flutter' or 'engine'
REPO='engine'
COMMIT='91c9fc8fe011352879e3bb6660966eafc0847233'
BUILDER='Linux beta Android AOT Engine'
FORCE_UPLOAD_FLAG='-p force_upload=true'
bb add \
  $FORCE_UPLOAD_FLAG \
  -commit "https://chromium.googlesource.com/external/github.com/flutter/$REPO/+/$COMMIT" \
  "flutter/prod/${BUILDER}"
