#!/bin/bash

set -uo pipefail

export GOMA_DIR="$HOME/flutter_goma"
readonly GOMA_AUTH="$GOMA_DIR/goma_auth.py"
readonly GOMA_CTL="$GOMA_DIR/goma_ctl.py"
readonly GOMACC="$GOMA_DIR/gomacc"
readonly GOMA_HTTP2_PROXY="$GOMA_DIR/http_proxy"
readonly GOMA_HTTP2_PROXY_PORT="8199"
GOMA_CACHE_DIR="$HOME/flutter_goma_cache"
# The URL of the backend cannot be read from prebuilt. Hard-code it for now.
BACKEND_URL="rbe-prod1.endpoints.fuchsia-infra-goma-prod.cloud.goog"

# Download client. Assumes cipd from depot_tools is on path.
echo 'fuchsia/third_party/goma/client/${platform}  release'
echo 'fuchsia/third_party/goma/client/${platform}  release' | cipd ensure -ensure-file - -root $GOMA_DIR

# Authenticate
"$GOMA_DIR/goma_auth" login
GOMA_LOCAL_OUTPUT_CACHE_DIR="$GOMA_CACHE_DIR" "$GOMA_CTL" ensure_start
