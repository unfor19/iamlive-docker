#!/usr/bin/env bash

set -e
set -o pipefail

_CERTS_DIR="${CERTS_DIR:-"/certs"}"
_CA_PATH="${CA_PATH:-"${_CERTS_DIR}/ca.pem"}"
_AWS_CA_PARAMETER_NAME="${AWS_CA_PARAMETER_NAME:-"/iamlive-docker/certs/ca.pem"}"

echo "Fetching ${_AWS_CA_PARAMETER_NAME} ..."
_RESPONSE="$(aws ssm get-parameter --name "$_AWS_CA_PARAMETER_NAME" \
    --with-decryption \
    --output text \
    --query Parameter.Value || true)"
if [[ "$_RESPONSE" =~ "-----BEGIN CERTIFICATE-----" ]]; then
    echo "Fetched ${_AWS_CA_PARAMETER_NAME} from SSM Parameter store"
    mkdir -p "$_CERTS_DIR"
    echo "Saving ${_CA_PATH} ..."
    echo "$_RESPONSE" > "$_CA_PATH"
    wait
    ls -lh "$_CA_PATH"
    echo "Saved ${_CA_PATH} successfully"
else
    echo "Failed to fetched ca.pem from SSM Parameter store"
    echo "$_RESPONSE"
    exit 1
fi
