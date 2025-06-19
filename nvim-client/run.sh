#!/usr/bin/env bash

# TODO cache builds

CUR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
pushd "$CUR"
	exec go run .
popd
