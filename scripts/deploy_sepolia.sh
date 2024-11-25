#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

sozo migrate --profile sepolia --wait