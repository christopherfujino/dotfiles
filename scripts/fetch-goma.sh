#!/bin/bash

# This script from https://github.com/flutter/flutter/wiki/Compiling-the-engine

# Customize this to where you would like Goma to be installed.
export GOMA_DIR="$HOME/flutter_goma"

# Download client. Assumes cipd from depot_tools is on path.
# NOTE: There is no arm64 Mac distribution of Goma, so you'll need to replace
#       `${platform}` with `mac-amd64` below if running an Apple Silicon Mac.
echo 'fuchsia/third_party/goma/client/${platform}  integration' | cipd ensure -ensure-file - -root "$GOMA_DIR"

# Authenticate
"$GOMA_DIR/goma_auth.py" login --browser

# Start Goma
GOMA_LOCAL_OUTPUT_CACHE_DIR="$GOMA_DIR/.goma_cache" "$GOMA_DIR/goma_ctl.py" ensure_start

# On macOS, have the build access xcode through symlinks in the build root. Required for goma builds to work.
if [ "$(uname)" == "Darwin" ]; then export FLUTTER_GOMA_CREATE_XCODE_SYMLINKS=1; fi
