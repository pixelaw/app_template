#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

echo $SCARB_PROFILE

# Get the profile from $SCARB_PROFILE
profile=${SCARB_PROFILE:-"dev"}

# Read values from dojo_${profile}.toml
config_file="dojo_${profile}.toml"

if [ ! -f "$config_file" ]; then
    echo "Error: $config_file not found"
    exit 1
fi

# Extract values using grep and cut
account_address=$(grep "account_address" "$config_file" | cut -d'"' -f2)
private_key=$(grep "private_key" "$config_file" | cut -d'"' -f2)
world_address=$(grep "world_address" "$config_file" | cut -d'"' -f2)

declare "CORE_ACTIONS"="pixelaw-actions"
declare "MYAPP_ACTIONS"="pixelaw-myapp_actions"

## Set RPC_URL with default value
#RPC_URL="http://localhost:5050"

# Check if a command line argument is supplied
if [ $# -gt 0 ]; then
    # If an argument is supplied, use it as the RPC_URL
    RPC_URL=$1
fi

# make sure all components/systems are deployed
CORE_MODELS=("pixelaw-App" "pixelaw-AppName" "pixelaw-CoreActionsAddress" "pixelaw-Pixel" "pixelaw-Permissions" "pixelaw-QueueItem" "pixelaw-Instruction")

echo "Write permissions for CORE_ACTIONS"
for model in ${CORE_MODELS[@]}; do
    sleep 0.1
    sozo --profile $SCARB_PROFILE auth grant writer model:$model,$CORE_ACTIONS
done
echo "Write permissions for CORE_ACTIONS: Done"

echo "Initialize CORE_ACTIONS : $CORE_ACTIONS"
sleep 0.1
sozo --profile $SCARB_PROFILE execute $CORE_ACTIONS init
echo "Initialize CORE_ACTIONS: Done"

sleep 0.1
sozo --profile $SCARB_PROFILE execute $MYAPP_ACTIONS init
echo "Initialize MYAPP_ACTIONS: Done"
