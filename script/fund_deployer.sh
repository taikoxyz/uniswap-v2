#!/bin/bash

# Define RPC URLs
RPC_URLS=(
 #"http://localhost:32002"
  "http://localhost:32005"
 # "http://localhost:32006"
)

# Loop through RPC URLs and run the scripts
for RPC_URL in "${RPC_URLS[@]}"; do
  echo "Running scripts for RPC URL: $RPC_URL"

  # First fund the deployer address
  echo "Funding deployer address..."
  forge script script/FundDeployer.s.sol --rpc-url $RPC_URL --broadcast --legacy
done
