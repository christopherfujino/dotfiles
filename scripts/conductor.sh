#!/usr/bin/env bash

FLUTTER_PATH="$HOME/git/flutter"
CONDUCTOR_PATH="$FLUTTER_PATH/dev/conductor/bin/conductor"

if [ ! -f "$CONDUCTOR_PATH" ]; then
  2>&1 echo "Conductor binary not found at $CONDUCTOR_PATH"
  exit 1
fi

# For incrementing:
#   - x major stable release bump
#   - y first dev release after a beta
#   - z stable hotfix release
#   - m initial dev release
#   - n beta hotfix release
export INCREMENT='m'

export FRAMEWORK_MIRROR='git@github.com:christopherfujino/flutter.git'
export ENGINE_MIRROR='git@github.com:christopherfujino/engine.git'
export CANDIDATE_BRANCH='flutter-2.8-candidate.16'
export RELEASE_CHANNEL='beta'
#export ENGINE_CHERRYPICKS='ffdaa4bb54c148bfe36216bfe6eebe326f423aa3,b0f3c0f7e478a02153107ac60817a11aa36c4c30,23cd1f96429b2c07f19209bd74150b4b023ccdb7'
#export FRAMEWORK_CHERRYPICKS='d50ec2469fef29d2707722e0a5e1ebc44bffc380,19722fb96c1544d507bb0331b89bfbb916b17bbf'
#export DART_REVISION='b41ae230a22e93bcbfb5716d513c208ae84922ff'

"$CONDUCTOR_PATH" $@
