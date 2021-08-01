#!/usr/bin/env bash

FLUTTER_PATH="$HOME/git/flutter"
CONDUCTOR_PATH="$FLUTTER_PATH/dev/tools/bin/conductor"

if [ ! -f "$CONDUCTOR_PATH" ]; then
  2>&1 echo "Conductor binary not found at $CONDUCTOR_PATH"
  exit 1
fi

export FRAMEWORK_MIRROR='git@github.com:christopherfujino/flutter.git'
export ENGINE_MIRROR='git@github.com:christopherfujino/engine.git'
export CANDIDATE_BRANCH='flutter-2.4-candidate.4'
export RELEASE_CHANNEL='beta'
export ENGINE_CHERRYPICKS='288983cea003e43037c306f558c7d9de970484c8'
#export FRAMEWORK_CHERRYPICKS=''
#export DART_REVISION='065872e802209ffa97aa3fad204758830b6100a0'

# For incrementing:
#   - x major stable release bump
#   - y first dev release after a beta
#   - z stable hotfix release
#   - m initial dev release
#   - n beta hotfix release
export INCREMENT='n'

"$CONDUCTOR_PATH" $@
