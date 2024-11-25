#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export DEFAULT_PROFILE=${1:-"sepolia"}

# Prompt the user for the account address
echo -e "This tool creates a keystore file from a private key, which you could export from your browser-wallet like Braavos or ArgentX \n"
echo -n "Enter the profile  [${DEFAULT_PROFILE}]:"
read PROFILE
PROFILE=${PROFILE:-$DEFAULT_PROFILE}

starkli signer keystore from-key ./accounts/$PROFILE.deployer.keystore.json