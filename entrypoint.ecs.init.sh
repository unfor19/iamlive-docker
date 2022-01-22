#!/usr/bin/env bash

set -e
set -o pipefail

_RESPONSE="$(aws ssm get-parameter --name "${AWS_CA_PARAMETER_NAME:-"/iamlive-docker/certs/ca.pem"}" \
    --with-decryption \
    --output text \
    --query Parameter.Value || true)"
if [[ "$_RESPONSE" =~ "-----BEGIN CERTIFICATE-----" ]]; then
    echo "$_RESPONSE" > ca.pem
else
    echo "$_RESPONSE"
    exit 1
fi
