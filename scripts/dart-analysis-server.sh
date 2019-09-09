#!/bin/bash

if [ -z "$DART_SDK" ]; then
  echo "Env var \$DART_SDK is not set!"
  exit 1
fi

$DART_SDK/bin/dart $DART_SDK/bin/snapshots/analysis_server.dart.snapshot --lsp
