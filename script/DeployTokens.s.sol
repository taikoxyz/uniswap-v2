// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6;

import {Script} from "../lib/forge-std/src/Script.sol";
import "forge-std/console2.sol";
import "../src/erc20/xERC20.sol";

contract DeployTokens is Script {

    address public constant DEPLOYER_ADDRESS = 0x614561D2d143621E126e87831AEF287678B442b8;
    uint256 public constant DEPLOYER_PK = 0x53321db7c1e331d93a11a41d16f004d7ff63972ec8ec7c25db329728ceeb1710;

    modifier broadcast() {
        vm.startBroadcast(DEPLOYER_PK);
        _;
        vm.stopBroadcast();
    }

    function run() public broadcast {
        address taikoAddress = address(new xERC20("Taiko", "TAIKO", 1_000_000_000 ether));
        console2.log("Deployed Taiko token:", taikoAddress);

        address slothAddress = address(new xERC20("Sloth", "SLOTH", 10_000_000_000 ether));
        console2.log("Deployed Sloth token:", slothAddress);

        address cheeseAddress = address(new xERC20("Cheese", "CHEESE", 350_000_000 ether));
        console2.log("Deployed Cheese token:", cheeseAddress);
    }
}