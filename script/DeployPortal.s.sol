// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6;

import {Script} from "../lib/forge-std/src/Script.sol";
import "forge-std/console2.sol";
import "../src/UniswapPortal.sol";

contract DeployPortal is Script {

    address public constant DEPLOYER_ADDRESS = 0x614561D2d143621E126e87831AEF287678B442b8;
    uint256 public constant DEPLOYER_PK = 0x53321db7c1e331d93a11a41d16f004d7ff63972ec8ec7c25db329728ceeb1710;

    modifier broadcast() {
        vm.startBroadcast(DEPLOYER_PK);
        _;
        vm.stopBroadcast();
    }

    function run() public broadcast {
        address uniswapPortal = address(new UniswapPortal(IUniswapV2Router02(0x7150a78fcE4dfa444597913Be969f7fd56CbcF41), 160010));
        console2.log("Deployed UniswapPortal token:", uniswapPortal);
    }
}