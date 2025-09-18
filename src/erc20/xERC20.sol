// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./CoreXERC20.sol";

contract xERC20 is CoreXERC20 {
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 totalSupply_
    ) CoreXERC20(name_, symbol_) {
        _mint(msg.sender, totalSupply_);
    }
}