#!/bin/bash

# Define RPC URLs
RPC_URLS=(
  "http://localhost:32002"
  "http://localhost:32005"
  "http://localhost:32006"
)

# Loop through RPC URLs and run the scripts
for RPC_URL in "${RPC_URLS[@]}"; do
  echo "Running scripts for RPC URL: $RPC_URL"

  forge script script/UniswapDeployer.s.sol --rpc-url $RPC_URL --broadcast --legacy
  forge script script/DeployTokens.s.sol --rpc-url $RPC_URL --broadcast --legacy

  # Only run DeployPortal for the last two RPC URLs
  if [[ "$RPC_URL" == "http://localhost:32005" || "$RPC_URL" == "http://localhost:32006" ]]; then
    forge script script/DeployPortal.s.sol --rpc-url $RPC_URL --broadcast --legacy
  fi
done
