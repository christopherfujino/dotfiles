#!/usr/bin/env bash

FLUTTER_PATH="$HOME/git/flutter"
CONDUCTOR_PATH="$FLUTTER_PATH/dev/tools/bin/conductor"

if [ ! -f "$CONDUCTOR_PATH" ]; then
  2>&1 echo "Conductor binary not found at $CONDUCTOR_PATH"
  exit 1
fi

export FRAMEWORK_MIRROR='git@github.com:christopherfujino/flutter.git'
export ENGINE_MIRROR='git@github.com:christopherfujino/engine.git'
export CANDIDATE_BRANCH='flutter-2.2-candidate.10'
export RELEASE_CHANNEL='dev'
#export ENGINE_CHERRYPICKS='eb658e840d92ab4e8a9862e912ab6a4351f5aa90,07fa0dc8ab532030a798fff45d18fb23338a86f8'
export FRAMEWORK_CHERRYPICKS='302e992ca7d5a16e1e44910ab98a7526f0d2d829,485c409184777c9a5eac0d65c362e00d080ea310,43d22ae2d38445e96ec865522da2e228ef392c4d'
export DART_REVISION='516eb3b05c252ef3d34255d06700c1f09f7f4502'

"$CONDUCTOR_PATH" $@
