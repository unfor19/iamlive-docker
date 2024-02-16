#!/usr/bin/env bash

set -e
set -o pipefail

_FORMAT_LOGS="${FORMAT_LOGS}"
_ALLOWED_ADDRESS="${ALLOWED_ADDRESS}"
_OUTPUT_PATH="${OUTPUT_PATH}"

if [[ "$_FORMAT_LOGS" = "true" ]]; then
    /app/iamlive --output-file "${_OUTPUT_PATH}" \
        --mode proxy --bind-addr "${_ALLOWED_ADDRESS}:10080" $@ | jq -c .
else
    /app/iamlive --output-file "${_OUTPUT_PATH}" \
        --mode proxy --bind-addr "${_ALLOWED_ADDRESS}:10080" $@
fi
