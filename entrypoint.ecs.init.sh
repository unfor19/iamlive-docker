#!/usr/bin/env bash

set -e
set -o pipefail

get_parameter(){
    local name="$1"
    aws ssm get-parameter --name "$name" \
        --with-decryption \
        --output text \
        --query Parameter.Value || true
    wait
}


_CERTS_DIR="${CERTS_DIR:-"/certs"}"
_BUNDLE_PATH="${CA_PATH:-"${_CERTS_DIR}/ca.pem"}"
_KEY_PATH="${KEY_PATH:-"${_CERTS_DIR}/ca.key"}"
_AWS_BUNDLE_PARAMETER_NAME="${AWS_BUNDLE_PARAMETER_NAME:-"/iamlive-docker/certs/ca.pem"}"
_AWS_CAKEY_PARAMETER_NAME="${AWS_CAKEY_PARAMETER_NAME:-"/iamlive-docker/certs/ca.key"}"

mkdir -p "$_CERTS_DIR"
echo "Fetching ${_AWS_BUNDLE_PARAMETER_NAME} ..."
_RESPONSE_BUNDLE="$(get_parameter "$_AWS_BUNDLE_PARAMETER_NAME")"
if [[ "$_RESPONSE_BUNDLE" =~ "-----BEGIN CERTIFICATE-----" ]]; then
    echo "Fetched ${_AWS_BUNDLE_PARAMETER_NAME} from SSM Parameter store"
    echo "Saving ${_BUNDLE_PATH} ..."
    echo "$_RESPONSE_BUNDLE" > "$_BUNDLE_PATH"
    wait
    ls -lh "$_BUNDLE_PATH"
    echo "Saved ${_BUNDLE_PATH} successfully"
else
    echo "Failed to fetch ${_AWS_BUNDLE_PARAMETER_NAME} from SSM Parameter store"
    echo "$_RESPONSE"
    exit 1
fi


echo "Fetching ${_AWS_CAKEY_PARAMETER_NAME} ..."
_RESPONSE_CAKEY="$(get_parameter "$_AWS_CAKEY_PARAMETER_NAME")"
if [[ "$_RESPONSE_CAKEY" =~ "-----BEGIN RSA PRIVATE KEY-----" ]]; then
    echo "Fetched ${_AWS_CAKEY_PARAMETER_NAME} from SSM Parameter store"
    echo "Saving ${_KEY_PATH} ..."
    echo "$_RESPONSE_CAKEY" > "$_KEY_PATH"
    wait
    ls -lh "$_KEY_PATH"
    echo "Saved ${_KEY_PATH} successfully"
else
    echo "Failed to fetch ${_AWS_CAKEY_PARAMETER_NAME} from SSM Parameter store"
    echo "$_RESPONSE_CAKEY"
    exit 1
fi
