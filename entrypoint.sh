#!/usr/bin/env bash

set -e
set -o pipefail

/app/iamlive --output-file "/app/iamlive.log" --mode proxy --bind-addr "0.0.0.0:10080" $@
