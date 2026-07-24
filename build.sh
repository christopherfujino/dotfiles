#!/usr/bin/env bash

cd "$(dirname "$(realpath "${BASH_SOURCE[0]}" )" )/templates"

exec ruby ./build.rb
