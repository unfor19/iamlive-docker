#!/usr/bin/env bash

set -e
set -o pipefail

_FORMAT_LOGS="${FORMAT_LOGS:-"true"}"

if [[ "$_FORMAT_LOGS" = "true" ]]; then
    /app/iamlive --output-file "/app/iamlive.log" \
        --mode proxy --bind-addr "0.0.0.0:10080" $@ 2>&1 | jq -c .
else
    /app/iamlive --output-file "/app/iamlive.log" \
        --mode proxy --bind-addr "0.0.0.0:10080" $@
fi
