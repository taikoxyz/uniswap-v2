// SPDX-License-Identifier: MIT
pragma solidity >=0.8.12 <0.9.0;

/**
 * @title EVM
 * @notice Library for cross-chain EVM operations and utilities
 * @dev Provides functionality for cross-chain calls using precompiled contracts
 */
library EVM {
    // ============ Constants ============

    /// @notice Address of the xCall options precompile
    address internal constant XCALL_OPTIONS_ADDRESS = address(0x04D2);

    /// @notice Magic bytes for xCall options verification
    bytes4 internal constant XCALL_OPTIONS_MAGIC = bytes4(keccak256("XCALLOPTIONS"));

    /// @notice Extension oracle address for cross-chain operations
    address payable internal constant EXTENSION_ORACLE = payable(0x1ADB9959EB142bE128E6dfEcc8D571f07cd66DeE);

    /// @notice Protocol version
    uint16 internal constant VERSION = 2;

    // ============ Structs ============

    /**
     * @notice Represents an address on a specific chain
     * @param chainId The chain identifier
     * @param addr The address on that chain
     */
    struct ChainAddr {
        uint256 chainId;
        address addr;
    }

    // ============ Helper Functions ============

    /**
     * @notice Creates a ChainAddr struct for a given address and chain
     * @param addr The address
     * @param targetChainId The chain identifier
     * @return ChainAddr struct containing the chain and address
     */
    function on(address addr, uint256 targetChainId) internal pure returns (ChainAddr memory) {
        return ChainAddr(targetChainId, addr);
    }

    /**
     * @notice Gets the current chain ID
     * @return The current chain identifier
     */
    function chainId() internal view returns (uint256) {
        return block.chainid;
    }

    // ============ XCall Options Functions ============

    /**
     * @notice Calls xCallOptions with default parameters (no sandbox)
     * @param targetChainId Target chain identifier
     * @param to Target address
     * @return success Whether the xCall options succeeded
     */
    function xCallOptions(uint256 targetChainId, address to) internal view returns (bool success) {
        return xCallOptions(targetChainId, to, false);
    }

    /**
     * @notice Calls xCallOptions with sandbox parameter using tx.origin and msg.sender
     * @param targetChainId Target chain identifier
     * @param to Target address
     * @param sandbox Whether to use sandbox mode
     * @return success Whether the xCall options succeeded
     */
    function xCallOptions(uint256 targetChainId, address to, bool sandbox) internal view returns (bool success) {
        return xCallOptions(targetChainId, to, sandbox, tx.origin, address(this));
    }

    /**
     * @notice Calls xCallOptions with explicit origin and sender addresses
     * @param targetChainId Target chain identifier
     * @param to Target address
     * @param sandbox Whether to use sandbox mode
     * @param txOrigin Transaction origin address
     * @param msgSender Message sender address
     * @return success Whether the xCall options succeeded
     */
    function xCallOptions(
        uint256 targetChainId,
        address to,
        bool sandbox,
        address txOrigin,
        address msgSender
    ) internal view returns (bool success) {
        return xCallOptions(targetChainId, to, sandbox, txOrigin, msgSender, bytes32(0), "");
    }

    /**
     * @notice Calls xCallOptions with block hash proof verification
     * @param targetChainId Target chain identifier
     * @param to Target address
     * @param sandbox Whether to use sandbox mode
     * @param blockHash Block hash for proof verification
     * @param proof Proof data
     * @return success Whether the xCall options succeeded
     */
    function xCallOptions(
        uint256 targetChainId,
        address to,
        bool sandbox,
        bytes32 blockHash,
        bytes memory proof
    ) internal view returns (bool success) {
        return xCallOptions(targetChainId, to, sandbox, address(0), address(0), blockHash, proof);
    }

    /**
     * @notice Main xCallOptions implementation with all parameters
     * @param targetChainId Target chain identifier
     * @param to Target address
     * @param sandbox Whether to use sandbox mode
     * @param txOrigin Transaction origin address
     * @param msgSender Message sender address
     * @param blockHash Block hash for proof verification
     * @param proof Proof data
     * @return success Whether the xCall options succeeded
     */
    function xCallOptions(
        uint256 targetChainId,
        address to,
        bool sandbox,
        address txOrigin,
        address msgSender,
        bytes32 blockHash,
        bytes memory proof
    ) internal view returns (bool success) {
        // Encode input data for the precompile
        bytes memory input = abi.encodePacked(
            VERSION,
            uint64(targetChainId),
            to,
            sandbox,
            txOrigin,
            msgSender,
            blockHash,
            proof
        );

        // Call the xCall options precompile
        (success, /*bytes memory result*/) = XCALL_OPTIONS_ADDRESS.staticcall(input);

        // Optional: Verify magic bytes from result
        // return success && bytes4(result) == XCALL_OPTIONS_MAGIC;
    }

    // ============ Cross-Chain Operations ============

    /**
     * @notice Returns the appropriate address for cross-chain operations
     * @dev If already on target chain, returns the address directly.
     *      Otherwise, sets up xCall options and returns the extension oracle.
     * @param to Target address
     * @param targetChainId Target chain identifier
     * @return The address to use for the operation
     */
    function onChain(address to, uint256 targetChainId) internal view returns (address) {
        // If we're already on the target chain, return the address directly
        if (targetChainId == block.chainid) {
            return to;
        }

        // Set up cross-chain call options
        require(xCallOptions(targetChainId, to, false), "EVM: xCallOptions failed");

        // Return the extension oracle which will route to the target address on L2
        return EXTENSION_ORACLE;
    }
}
