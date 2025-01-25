pragma solidity ^0.8.20;

import "./IUniswapV2Router02.sol";
import "./erc20/xERC20.sol";

contract UniswapPortal {
    IUniswapV2Router02 public uniswapRouter;
    uint64 public parentChainId;

    constructor(
        IUniswapV2Router02 _uniswapRouter,
        uint64 _parentChainId
    ) {
        uniswapRouter = _uniswapRouter;
        parentChainId = _parentChainId;
    }

    function approveToken(
        address token,
        address spender,
        uint256 amount
    ) external returns (bool) {
        // Call the approve function on the specified token
        bool success = xERC20(token).approve(spender, amount);
        require(success, "Approval failed");
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
        EVM.xCallOptions(parentChainId);
        amounts = uniswapRouter.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            address(this),
            deadline
        );

        // Get the tokens from L1 back to the user's L2 account
        xERC20(path[1]).xTransfer(parentChainId, block.chainid, msg.sender, amounts[1]);
    }
}
