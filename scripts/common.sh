#!/usr/bin/env bash


# This will canonicalize the path
PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd -P)


source "${PROJECT_ROOT}/scripts/comm/ini.sh"


TMP_PATH="${PROJECT_ROOT}/_tmp"
