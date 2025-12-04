// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6;

import {Script} from "../lib/forge-std/src/Script.sol";
import "forge-std/console.sol";
import {UniswapV2Router01} from "@uniswap/v2-periphery/contracts/UniswapV2Router01.sol";
import {UniswapV2Router02} from "@uniswap/v2-periphery/contracts/UniswapV2Router02.sol";
import {Multicall} from "multicall/Multicall.sol";

/// Deploys WETH9, Factory, Router01/02, and Multicall from compiled artifacts via deployCode.
contract UniswapDeployer is Script {
    address public constant DEPLOYER_ADDRESS = 0x394Fb4f9fA0F8981E648B2Dd11c973561898C7db;

    modifier broadcast() {
        uint256 deployerPK = vm.envUint("DEPLOYER_PK");
        vm.startBroadcast(deployerPK);
        _;
        vm.stopBroadcast();
    }

    function run() public broadcast {
        address weth = _deploy("out/WETH9.sol/WETH9.json", "");
        console.log("WETH deployed at:", weth);

        address factory = _deploy(
            "out/UniswapV2Factory.sol/UniswapV2Factory.json", abi.encode(DEPLOYER_ADDRESS)
        );
        console.log("UniswapV2Factory deployed at:", factory);

        UniswapV2Router01 router1 = new UniswapV2Router01(factory, weth);
        console.log("Router01 deployed at:", address(router1));

        UniswapV2Router02 router2 = new UniswapV2Router02(factory, weth);
        console.log("Router02 deployed at:", address(router2));

        Multicall multiCall = new Multicall();
        console.log("Deployed Multicall contract:", address(multiCall));
    }

    function _deploy(string memory artifactPath, bytes memory args) internal returns (address addr) {
        addr = args.length == 0 ? vm.deployCode(artifactPath) : vm.deployCode(artifactPath, args);
        require(addr != address(0), "deploy failed");
    }
}
