pragma solidity ^0.8.20;

import "./IUniswapV2Router01.sol";
import "./erc20/xERC20.sol";

contract UniswapPortal {
    IUniswapV2Router01 public uniswapRouter;
    uint64 public parentChainId;
    address public pool;

    constructor(
        IUniswapV2Router01 _uniswapRouter,
        uint64 _parentChainId,
        address _pool
    ) {
        uniswapRouter = _uniswapRouter;
        parentChainId = _parentChainId;
        pool = _pool;
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
            to,
            deadline
        );

        // Get the tokens from L1 back to the user's L2 account
        xERC20(path[1]).xTransfer(parentChainId, block.chainid, msg.sender, amounts[1]);
    }
}