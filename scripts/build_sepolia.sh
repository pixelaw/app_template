#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

sozo build --profile sepolia 