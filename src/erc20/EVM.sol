// SPDX-License-Identifier: MIT

pragma solidity >=0.8.12 <0.9.0;
// EVM library
library EVM {
    address constant xCallOptionsAddress = address(0x04D2);
    bytes4 constant xCallOptionsMagic = bytes4(keccak256("XCALLOPTIONS"));
    address payable constant extensionOracle = payable(0x1ADB9959EB142bE128E6dfEcc8D571f07cd66DeE);

    uint16 constant version = 1;

    struct ChainAddr {
        uint chain_id;
        address addr;
    }

    function on(address addr, uint chain_id) internal pure returns(ChainAddr memory) {
        return ChainAddr(chain_id, addr);
    }

    function xCallOptions(uint chainID, address to)
        internal
        view
        returns (bool)
    {
        return xCallOptions(chainID, to, false);
    }

    function xCallOptions(uint chainID, address to, bool sandbox)
        internal
        view
        returns (bool)
    {
        return xCallOptions(chainID, to, sandbox, tx.origin, address(this));
    }

    function xCallOptions(uint chainID, address to, bool sandbox, address txOrigin, address msgSender)
        internal
        view
        returns (bool)
    {
        return xCallOptions(chainID, to, sandbox, txOrigin, msgSender, 0x0, "");
    }

    function xCallOptions(uint chainID, address to, bool sandbox, bytes32 blockHash, bytes memory proof)
        internal
        view
        returns (bool)
    {
        return xCallOptions(chainID, to, sandbox, address(0), address(0), blockHash, proof);
    }

    function xCallOptions(uint chainID, address to, bool sandbox, address txOrigin, address msgSender, bytes32 blockHash, bytes memory proof)
        internal
        view
        returns (bool)
    {
        // Call the custom precompile
        bytes memory input = abi.encodePacked(version, uint64(chainID), to, sandbox, txOrigin, msgSender, blockHash, proof);
        (bool success, /*bytes memory result*/) = xCallOptionsAddress.staticcall(input);
        return success/* && bytes4(result) == xCallOptionsMagic*/;
    }

    function chainId() internal view returns (uint256) {
        return block.chainid;
    }

    function onChain(address to, uint chainID)
        internal
        view
        returns (address)
    {
        // If we're already on the target chain, don't do anything
        if (chainID == block.chainid) {
            return to;
        } else {
            require(xCallOptions(chainID, to, false), "EVM: xCallOptions failed");
            // Always return the extension oracle,
            // switch to the target address on L2
            return extensionOracle;
        }
    }
}