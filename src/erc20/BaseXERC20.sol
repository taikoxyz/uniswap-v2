// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./EVM.sol";
import "../gwyneth/GwynethContract.sol";

contract BaseXERC20 is ERC20, GwynethContract {
    mapping(address to => mapping(uint256 chainid => uint256[] values)) public asyncTransfers;

    using EVM for address;
    using EVM for address payable;

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    function ChainAddress(uint256 chainId, BaseXERC20 contractAddr) internal view returns (BaseXERC20) {
        return BaseXERC20(address(contractAddr).onChain(chainId));
    }

    function on(uint256 chainId) internal view returns (BaseXERC20) {
        return ChainAddress(chainId, this);
    }

    // Cross-chain transfer functions
    function xTransfer(uint256 fromChain, uint256 toChain, address to, uint256 value) public returns (bool) {
        return on(fromChain)._xTransfer(msg.sender, toChain, to, value);
    }

    function _xTransfer(address from, uint256 chain, address to, uint256 value) public returns (bool) {
        require(msg.sender == address(this), "Only contract itself can call this function");
        _burn(from, value);
        on(chain)._mintCrossChain(to, value);
        return true;
    }

    function xTransfer(uint256 chain, address to, uint256 value) public returns (bool) {
        _burn(msg.sender, value);
        on(chain)._mintCrossChain(to, value);
        return true;
    }

    // Public mint for cross-chain calls only
    function _mintCrossChain(address to, uint256 value) public returns (bool) {
        require(msg.sender == address(this), "Only contract itself can call this function");
        _mint(to, value);
        return true;
    }

    // Async transfer functions
    function xTransferAsync(uint256 dstChain, address to, uint256 value) public returns (bool) {
        require(dstChain != block.chainid, "xERC20::transfer: invalid chain");
        require(value != 0, "xERC20::transfer: zero value");
        _burn(msg.sender, value);
        asyncTransfers[to][dstChain].push(value);
        return true;
    }

    function mintAsync(uint256 srcChain, address to, uint256 maxIterations) public returns (uint256) {
        uint counter = 0;
        uint i = asyncTransfers[to][srcChain].length;
        while(on(srcChain).asyncTransfers(to, srcChain, i) != 0 && counter < maxIterations) {
            uint256 value = on(srcChain).asyncTransfers(to, srcChain, i);
            asyncTransfers[to][srcChain].push(value);
            _mint(to, value);
            i++;
            counter++;
        }
        return counter;
    }

    // Cross-chain approval
    function xApprove(uint256 chain, address spender, uint256 value) public returns (bool) {
        return on(chain)._approveCrossChain(msg.sender, spender, value);
    }

    function _approveCrossChain(address owner, address spender, uint256 value) public returns (bool) {
        require(msg.sender == address(this), "Only contract itself can call this function");
        _approve(owner, spender, value);
        return true;
    }

    // Cross-chain transferFrom
    function xTransferFrom(address from, uint256 chain, address to, uint256 value) public returns (bool) {
        uint256 currentAllowance = allowance(from, msg.sender);
        require(balanceOf(from) >= value, "xERC20::xTransferFrom: Insufficient balance");
        
        if (from != msg.sender) {
            require(currentAllowance >= value, "xERC20::xTransferFrom: Allowance exceeded");
            _approve(from, msg.sender, currentAllowance - value);
        }
        
        _burn(from, value);
        emit Transfer(from, address(0), value);
        on(chain)._mintCrossChain(to, value);
        
        return true;
    }

    // ETH transfer functions (keep as-is for compatibility)
    function sendETH(uint256 chain, address payable to) external payable returns (bool) {
        (bool success, ) = to.onChain(chain).call{value: msg.value}("");
        require(success, "ETH transfer failed");
        return success;
    }

    function sendETHFrom(uint256 fromChain, uint256 toChain, address payable to) external payable returns (bool) {
        return on(fromChain).sendETH{value: msg.value}(toChain, to);
    }
}