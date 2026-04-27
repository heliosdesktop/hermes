#!/usr/bin/env bash
set -e

build_type="$(printf '%s' "${BUILD_TYPE:-}" | tr '[:upper:]' '[:lower:]')"

if [[ "$build_type" == "release" ]]; then
  cmake -S hermes -B build_release -G Ninja -DCMAKE_BUILD_TYPE=Release
  cmake --build ./build_release
else
  cmake -S hermes -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
  cmake --build ./build
fi
