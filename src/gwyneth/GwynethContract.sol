// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GwynethContract {
    address payable private constant gwyneth = payable(0x9fCF7D13d10dEdF17d0f24C62f0cf4ED462f65b7);

    function gwynethForwarder()
        external
        payable
    {
        require(msg.sender == gwyneth, "GwynethContract: gwynethForwarder called not from gwyneth");
        assembly {
            let cds := calldatasize()
            let len := sub(cds, 36)        // strip 4 (selector) + 32 (address)

            // copy calldata[4..cds-32] -> mem[0..len]
            calldatacopy(0, 4, len)

            // load address = last 32 bytes, low 20 bytes
            let pos := sub(cds, 32)
            let addr := and(calldataload(pos), 0xffffffffffffffffffffffffffffffffffffffff)

            // delegatecall(gas, addr, 0, len, 0, 0)
            let ok := delegatecall(gas(), addr, 0, len, 0, 0)
            let rds := returndatasize()
            returndatacopy(0, 0, rds)
            switch ok
            case 0 { revert(0, rds) }
            default { return(0, rds) }
        }
    }
}
