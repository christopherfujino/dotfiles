#!/bin/bash

readonly GOMA_AUTH="$HOME/flutter_goma/goma_auth.py"
readonly GOMA_CTL="$HOME/flutter_goma/goma_ctl.py"
readonly GOMACC="$HOME/flutter_goma/gomacc"
readonly GOMA_HTTP2_PROXY="$HOME/flutter_goma/http_proxy"
readonly GOMA_HTTP2_PROXY_PORT="8199"
GOMA_CACHE_DIR="$HOME/flutter_goma_cache"
# The URL of the backend cannot be read from prebuilt. Hard-code it for now.
BACKEND_URL="rbe-prod1.endpoints.fuchsia-infra-goma-prod.cloud.goog"

# Download client. Assumes cipd from depot_tools is on path.
echo 'fuchsia/third_party/goma/client/${platform}  release'
echo 'fuchsia/third_party/goma/client/${platform}  release' | cipd ensure -ensure-file - -root $HOME/flutter_goma

# Authenticate
$HOME/flutter_goma/goma_auth login
GOMA_LOCAL_OUTPUT_CACHE_DIR="$GOMA_CACHE_DIR" "$GOMA_CTL" ensure_start
