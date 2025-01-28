#!/bin/bash

echo "Starting contract verification across all chains..."

# Chain 1 (160010) - Port 64001
echo "Verifying contracts on chain 160010..."
forge verify-contract 0x534Cf76B8D56ab71caC1c211c9B38C81cA8E4B45 "src/erc20/xERC20.sol:xERC20" --watch --verifier-url "http://localhost:64001/api" --verifier blockscout --chain-id 160010 --skip-is-verified-check --constructor-args "Taiko","TAIKO"
echo "Verified Taiko contract on chain 160010"

forge verify-contract 0xA12297e9F5B9E9Ca7A810725904aFAf13a1eD568 "src/erc20/xERC20.sol:xERC20" --watch --verifier-url "http://localhost:64001/api" --verifier blockscout --chain-id 160010 --skip-is-verified-check --constructor-args "Sloth","SLOTH"
echo "Verified Sloth contract on chain 160010"

forge verify-contract 0x6B2345898C657861F13C6408b73c82bb39784ec2 "src/erc20/xERC20.sol:xERC20" --watch --verifier-url "http://localhost:64001/api" --verifier blockscout --chain-id 160010 --skip-is-verified-check --constructor-args "Cheese","CHEESE"
echo "Verified Cheese contract on chain 160010"

# Chain 2 (167010) - Port 64003
echo "Verifying contracts on chain 167010..."
forge verify-contract 0x534Cf76B8D56ab71caC1c211c9B38C81cA8E4B45 "src/erc20/xERC20.sol:xERC20" --watch --verifier-url "http://localhost:64003/api" --verifier blockscout --chain-id 167010 --skip-is-verified-check --constructor-args "Taiko","TAIKO"
echo "Verified Taiko contract on chain 167010"

forge verify-contract 0xA12297e9F5B9E9Ca7A810725904aFAf13a1eD568 "src/erc20/xERC20.sol:xERC20" --watch --verifier-url "http://localhost:64003/api" --verifier blockscout --chain-id 167010 --skip-is-verified-check --constructor-args "Sloth","SLOTH"
echo "Verified Sloth contract on chain 167010"

forge verify-contract 0x6B2345898C657861F13C6408b73c82bb39784ec2 "src/erc20/xERC20.sol:xERC20" --watch --verifier-url "http://localhost:64003/api" --verifier blockscout --chain-id 167010 --skip-is-verified-check --constructor-args "Cheese","CHEESE"
echo "Verified Cheese contract on chain 167010"

# Chain 3 (167011) - Port 64005
echo "Verifying contracts on chain 167011..."
forge verify-contract 0x534Cf76B8D56ab71caC1c211c9B38C81cA8E4B45 "src/erc20/xERC20.sol:xERC20" --watch --verifier-url "http://localhost:64005/api" --verifier blockscout --chain-id 167011 --skip-is-verified-check --constructor-args "Taiko","TAIKO"
echo "Verified Taiko contract on chain 167011"

forge verify-contract 0xA12297e9F5B9E9Ca7A810725904aFAf13a1eD568 "src/erc20/xERC20.sol:xERC20" --watch --verifier-url "http://localhost:64005/api" --verifier blockscout --chain-id 167011 --skip-is-verified-check --constructor-args "Sloth","SLOTH"
echo "Verified Sloth contract on chain 167011"

forge verify-contract 0x6B2345898C657861F13C6408b73c82bb39784ec2 "src/erc20/xERC20.sol:xERC20" --watch --verifier-url "http://localhost:64005/api" --verifier blockscout --chain-id 167011 --skip-is-verified-check --constructor-args "Cheese","CHEESE"
echo "Verified Cheese contract on chain 167011"

echo "All contract verifications complete!"