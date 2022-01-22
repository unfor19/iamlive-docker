#!/usr/bin/env bash

set -e
set -o pipefail

_RESPONSE="$(aws ssm get-parameter --name "${AWS_CA_PARAMETER_NAME:-"/iamlive-docker/certs/ca.pem"}" \
    --with-decryption \
    --output text \
    --query Parameter.Value || true)"
if [[ "$_RESPONSE" =~ "-----BEGIN CERTIFICATE-----" ]]; then
    echo "Fetched ca.pem from SSM Parameter store"
    echo "Saving ca.pem ..."
    mkdir -p /certs
    echo "$_RESPONSE" > /certs/ca.pem
    echo "Saved ca.pem successfully"
else
    echo "Failed to fetched ca.pem from SSM Parameter store"
    echo "$_RESPONSE"
    exit 1
fi
