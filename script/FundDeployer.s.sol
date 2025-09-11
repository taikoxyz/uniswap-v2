// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";

contract FundDeployer is Script {
    // L1 funded address (has ETH on L1)
    address public constant L1_FUNDED_ADDRESS = 0xE25583099BA105D9ec0A67f5Ae86D90e50036425;
    uint256 public constant L1_FUNDED_PK = 0x39725efee3fb28614de3bacaffe4cc4bd8c436257e2c8bb887c4b5c4be45e76d;
    
    // L2 funded address (has ETH on L2A and L2B)
    address public constant L2_FUNDED_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 public constant L2_FUNDED_PK = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    
    // Target deployer address (needs ETH)
    address public constant DEPLOYER_ADDRESS = 0x394Fb4f9fA0F8981E648B2Dd11c973561898C7db;
    
    // Amount to send (1 ETH)
    uint256 public constant FUND_AMOUNT = 1 ether;
    
    function run() external {
        // Determine which funded address to use based on chain ID
        uint256 chainId = block.chainid;
        address fundedAddress;
        uint256 fundedPK;
        
        if (chainId == 1 || chainId == 160010 || chainId == 560048) { // L1 or similar
            fundedAddress = L1_FUNDED_ADDRESS;
            fundedPK = L1_FUNDED_PK;
            console.log("Using L1 funded address for chain ID:", chainId);
        } else {
            fundedAddress = L2_FUNDED_ADDRESS;
            fundedPK = L2_FUNDED_PK;
            console.log("Using L2 funded address for chain ID:", chainId);
        }
        
        // Start broadcasting transactions from the appropriate funded address
        vm.startBroadcast(fundedPK);
        
        // Check current balance of funded address
        uint256 senderBalance = fundedAddress.balance;
        console.log("Funded address:", fundedAddress);
        console.log("Funded address balance:", senderBalance);
        console.log("Target deployer address:", DEPLOYER_ADDRESS);
        console.log("Amount to send:", FUND_AMOUNT);
        
        // Verify sufficient balance
        require(senderBalance >= FUND_AMOUNT, "Insufficient balance to fund deployer");
        
        // Transfer ETH to deployer address
        (bool success, ) = payable(DEPLOYER_ADDRESS).call{value: FUND_AMOUNT}("");
        require(success, "ETH transfer failed");
        
        console.log("Successfully funded deployer with", FUND_AMOUNT, "wei");
        console.log("Deployer new balance:", DEPLOYER_ADDRESS.balance);
        
        vm.stopBroadcast();
    }
}