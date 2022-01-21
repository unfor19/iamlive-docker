#!/usr/bin/env bash

set -e
set -o pipefail

# Requires - openssl
_CERTS_DIR_PATH="${CERTS_DIR_PATH:-".certs"}"
mkdir -p "$_CERTS_DIR_PATH"
pushd "$_CERTS_DIR_PATH" || exit

_SKIP_ROOTCA_KEY="${SKIP_ROOT_CA_KEY:-"false"}"
_ROOTCA_KEY_PATH="${ROOTCA_KEY_PATH:-"ca.key"}"
_ROOTCA_PEM_PATH="${CERT_OUT_PATH:-"ca.pem"}"
_ROOTCA_CERT_EXPIRE_DAYS="${ROOTCA_CERT_EXPIRE_DAYS:-"3650"}"

### Root CA

if [[ "$_SKIP_ROOTCA_KEY" != "true" ]]; then
  if [[ ! -f "$_ROOTCA_KEY_PATH" ]]; then
    echo "Generating private key for rootCA"
    # 2048 bit key is hardcoded on purpose - https://expeditedsecurity.com/blog/measuring-ssl-rsa-keys/
    openssl genrsa -out "$_ROOTCA_KEY_PATH" 2048
  fi
  if [[ ! -f "$_ROOTCA_PEM_PATH" ]]; then
    echo "Generating the rootCA Certificate ${_ROOTCA_PEM_PATH} and signing it with the private key ${_ROOTCA_KEY_PATH}"
    openssl req -new \
    -x509 \
    -days "$_ROOTCA_CERT_EXPIRE_DAYS" \
    -key "$_ROOTCA_KEY_PATH" \
    -out "$_ROOTCA_PEM_PATH" \
    -subj "/C=IL/O=rootCaOrg"
  fi
fi

echo "
rootCA Certificate: ${_ROOTCA_PEM_PATH}
rootCA Private Key: ${_ROOTCA_KEY_PATH}
"

popd || exit
