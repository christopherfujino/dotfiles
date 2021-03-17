#!/usr/bin/env bash

FLUTTER_PATH="$HOME/git/flutter"
CONDUCTOR_PATH="$FLUTTER_PATH/dev/tools/bin/conductor"

if [ ! -f "$CONDUCTOR_PATH" ]; then
  2>&1 echo "Conductor binary not found at $CONDUCTOR_PATH"
  exit 1
fi

export FRAMEWORK_MIRROR='git@github.com:christopherfujino/flutter.git'
export ENGINE_MIRROR='git@github.com:christopherfujino/engine.git'
export CANDIDATE_BRANCH='flutter-1.27-candidate.12'
export RELEASE_CHANNEL='beta'
export ENGINE_CHERRYPICKS='48cf2b937,95cb19f9b'
export FRAMEWORK_CHERRYPICKS='781eb13,6afbb25a4,d75c2781,a7f7687a'

"$CONDUCTOR_PATH" $@
