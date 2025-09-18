// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6;

import {Script} from "../lib/forge-std/src/Script.sol";
import "forge-std/console2.sol";
import "../src/erc20/xERC20.sol";

contract DeployTokens is Script {

    address public constant DEPLOYER_ADDRESS = 0x394Fb4f9fA0F8981E648B2Dd11c973561898C7db;

    modifier broadcast() {
        uint256 deployerPK = vm.envUint("DEPLOYER_PK");
        vm.startBroadcast(deployerPK);
        _;
        vm.stopBroadcast();
    }

    function run() public broadcast {
        address taikoAddress = address(new xERC20("Taiko", "TAIKO", 5_000 ether));
        console2.log("Deployed Taiko token:", taikoAddress);

        address slothAddress = address(new xERC20("Sloth", "SLOTH", 7_500 ether));
        console2.log("Deployed Sloth token:", slothAddress);

        address cheeseAddress = address(new xERC20("Cheese", "CHEESE", 9_000 ether));
        console2.log("Deployed Cheese token:", cheeseAddress);
    }
}