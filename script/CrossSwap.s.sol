// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import {Script} from "../lib/forge-std/src/Script.sol";

import {UniswapPortal} from "../src/UniswapPortal.sol";
 import {xERC20} from "../src/erc20/xERC20.sol";

contract CrossSwap is Script {
    address public constant DEPLOYER_ADDRESS = 0x614561D2d143621E126e87831AEF287678B442b8;
    uint256 public constant DEPLOYER_PK = 0x53321db7c1e331d93a11a41d16f004d7ff63972ec8ec7c25db329728ceeb1710;

    modifier broadcast() {
        vm.startBroadcast(DEPLOYER_PK);
        _;
        vm.stopBroadcast();
    }

    function run() public broadcast {
        address slothToken = 0xA12297e9F5B9E9Ca7A810725904aFAf13a1eD568;
        address taikoToken = 0x534Cf76B8D56ab71caC1c211c9B38C81cA8E4B45;

        //1. Approve UniswapPortal as spender
        xERC20 sloth = xERC20(slothToken);
        sloth.approve(
            0x84FB3688D1ee5dCD0137746A07290f8bE55ec04E,
            100000000000000000000
        );

        //This is the real: 0x84FB3688D1ee5dCD0137746A07290f8bE55ec04E
        UniswapPortal portalContract = UniswapPortal(0x84FB3688D1ee5dCD0137746A07290f8bE55ec04E);

        //2. Make UniswapPortal's allowance's spender the actual Router contract (cause happens another transferFrom in the router)
        portalContract.approveToken(
            0xA12297e9F5B9E9Ca7A810725904aFAf13a1eD568,
            0x7150a78fcE4dfa444597913Be969f7fd56CbcF41,
            100000000000000000000
        );

        address[] memory paths = new address[](2);
        paths[0] = slothToken;
        paths[1] = taikoToken;

        // 3. Do the cross-swap
        portalContract.swapExactTokensForTokens(
            500000000000000000,
            0,
            paths,
            0x614561D2d143621E126e87831AEF287678B442b8,
            1737726556
        );

    }
}