#!/bin/bash
#
# Copyright (C) 2018 - 2019 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=daisy
VENDOR=xiaomi

INITIAL_COPYRIGHT_YEAR=2019

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

ROOT="$MY_DIR"/../../..

HELPER="$ROOT"/vendor/lineage/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# Initialize the helper for device
setup_vendor "$DEVICE" "$VENDOR" "$ROOT"

# Copyright headers and guards
write_headers "$DEVICE"

# The standard device blobs
write_makefiles "$MY_DIR"/proprietary-files.txt true

# We are done!
write_footers
