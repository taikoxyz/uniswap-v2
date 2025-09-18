// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6;

import {Script} from "../lib/forge-std/src/Script.sol";
import "forge-std/console2.sol";
import "../src/UniswapPortal.sol";

contract DeployPortal is Script {

    address public constant DEPLOYER_ADDRESS = 0x394Fb4f9fA0F8981E648B2Dd11c973561898C7db;

    modifier broadcast() {
        uint256 deployerPK = vm.envUint("DEPLOYER_PK");
        vm.startBroadcast(deployerPK);
        _;
        vm.stopBroadcast();
    }

    function run() public broadcast {
        // Todo: Change the parent chain ID as needed
        address uniswapPortal = address(new UniswapPortal(IUniswapV2Router02(0x81AD261779F07B5F5F8914A3C5Ea929Cec9c168c), 160010));
        console2.log("Deployed UniswapPortal token:", uniswapPortal);
    }
}