#!/usr/bin/env bash

# To get commit a release branch branched off of:
# $ export COMMIT_DATE=$(git merge-base master HEAD \
#    | xargs git show --format='%ci' --no-patch)

BRANCH='master'
git rev-list -1 --before="$COMMIT_DATE" "$BRANCH"
