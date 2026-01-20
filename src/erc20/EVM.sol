// SPDX-License-Identifier: MIT
pragma solidity >=0.8.12 <0.9.0;

/**
 * @title EVM
 * @notice Library for cross-chain EVM operations and utilities
 * @dev Provides functionality for cross-chain calls using precompiled contracts
 */
library EVM {
    address internal constant XCALL_OPTIONS_ADDRESS = address(0x04D2);
    bytes4 internal constant XCALL_OPTIONS_MAGIC = bytes4(keccak256("XCALLOPTIONS"));
    address payable internal constant EXTENSION_ORACLE =
        payable(0x1ADB9959EB142bE128E6dfEcc8D571f07cd66DeE);

    uint16 internal constant VERSION = 1;

    struct ChainAddr {
        uint256 chainId;
        address addr;
    }

    function on(address addr, uint256 targetChainId) internal pure returns (ChainAddr memory) {
        return ChainAddr(targetChainId, addr);
    }

    function chainId() internal view returns (uint256) {
        return block.chainid;
    }

    function xCallOptions(uint256 targetChainId, address to) internal view returns (bool success) {
        return xCallOptions(targetChainId, to, false);
    }

    function xCallOptions(uint256 targetChainId, address to, bool direct) internal view returns (bool success) {
        bytes memory input = abi.encodePacked(VERSION, uint64(targetChainId), to, direct);
        (success, ) = XCALL_OPTIONS_ADDRESS.staticcall(input);
    }

    function onChain(address to, uint256 targetChainId) internal view returns (address) {
        return onChain(to, targetChainId, false);
    }

    function onChain(address to, uint256 targetChainId, bool direct) internal view returns (address) {
        if (targetChainId == block.chainid) {
            return to;
        }

        require(xCallOptions(targetChainId, to, direct), "EVM: xCallOptions failed");
        return EXTENSION_ORACLE;
    }
}
