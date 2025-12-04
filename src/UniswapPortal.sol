pragma solidity ^0.8.20;

import "./IUniswapV2Router02.sol";
import "./erc20/xERC20.sol";

contract UniswapPortal {
    using EVM for address;
    using EVM for address payable;
    
    // Made immutable - will be stored in contract code
    IUniswapV2Router02 public immutable uniswapRouter;
    uint64 public immutable parentChainId;

    constructor(
        IUniswapV2Router02 _uniswapRouter,
        uint64 _parentChainId
    ) {
        uniswapRouter = _uniswapRouter;
        parentChainId = _parentChainId;
    }

    // For testing
    function approveToken(
        uint256 chain,
        address token,
        address spender,
        uint256 amount
    ) external returns (bool) {
        // Call the approve function on the specified token
        bool success = xERC20(token).xApprove(chain, spender, amount);
        require(success, "Approval failed");
        return success;
    }

    // For testing
    function xTransferToken(
        address token,
        uint256 fromChain,
        uint256 toChain,
        address to,
        uint256 amount
    ) external returns (bool) {
        // Call the approve function on the specified token
        bool success = xERC20(token).xTransfer(fromChain, toChain, to, amount);
        require(success, "Transfer failed");
        return success;
    }

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts) {
        // Transfer tokens to L1
        // The user needs to approve this contract for spending (on L2)
        xERC20(path[0]).xTransferFrom(msg.sender, parentChainId, address(this), amountIn);

        // Do the swap on L1 like normal
        amounts = UniswapPortal(address(this).onChain(parentChainId))._swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline,
            block.chainid
        );
    }

    function _swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline,
        uint toChainId
    ) external returns (uint[] memory amounts) {
        require(msg.sender == address(this), "only self calls allowed");

        // Approve the tokenFrom done inside the uniswapRouter
        xERC20(path[0]).approve(address(uniswapRouter), amountIn);

        // Do the swap on L1 like normal
        amounts = uniswapRouter.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            address(this),
            deadline
        );

        // Get the tokens from L1 back to the user's L2 account
        xERC20(path[1]).xTransfer(toChainId, to, amounts[1]);
    }
}
