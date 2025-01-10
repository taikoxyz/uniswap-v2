// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@oz/contracts/token/ERC20/IERC20.sol";
import "../lib/EVM.sol";
import "../gwyneth/GwynethContract.sol";

contract xERC20 is IERC20, GwynethContract {
    // These are relevant on the chain currently active (so not overall / token)
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public _allowances;

    // event Transfer(address indexed from, address indexed to, uint256 value);
    // event Approval(address indexed owner, address indexed spender, uint256 value);

    string private _name;
    string private _symbol;
    uint256 private _totalSupply;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_, uint256 totalSupply_) {
        _name = name_;
        _symbol = symbol_;
        _totalSupply = totalSupply_;
        balanceOf[msg.sender] = totalSupply_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-_allowances}.
     */
    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) public returns (uint256) {
        require(msg.sender == address(this), "Only this contract can mint");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        return value;
    }

    function _mint(address to, uint256 value) public returns (uint256) {
        require(msg.sender == address(this), "Only this contract can mint");
        balanceOf[to] += value;
        return value;
    }

    function xTransfer(uint256 fromChain, uint256 toChain, address to, uint256 value) public returns (uint256) {
        EVM.xCallOptions(fromChain);
        return this._xTransfer(msg.sender, toChain, to, value);
    }

    function _xTransfer(address from, uint256 chain, address to, uint256 value) external returns (uint256) {
        require(msg.sender == address(this), "Only contract itself can call this function");
        balanceOf[from] -= value;
        EVM.xCallOptions(chain);
        return this._mint(to, value);
    }

    function xTransfer(uint256 chain, address to, uint256 value) public returns (uint256) {
        balanceOf[msg.sender] -= value;
        EVM.xCallOptions(chain);
        return this._mint(to, value);
    }

    function sandboxedTransfer(uint256 chain, address to, uint256 value) public returns (uint256) {
        EVM.xCallOptions(chain, true);
        return this._transfer(msg.sender, to, value);
    }

    function approve(address spender, uint256 value) public returns (bool) {
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function _approve(address owner, address spender, uint256 value) public returns (uint256) {
        require(msg.sender == address(this), "Only contract itself can call this function");
        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
        return value;
    }

    function xApprove(uint256 chain, address spender, uint256 value) public returns (uint256) {
        EVM.xCallOptions(chain);
        return this._approve(msg.sender, spender, value);
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(balanceOf[from] >= value, "Insufficient balance");
        if (from != msg.sender) {
            require(_allowances[from][msg.sender] >= value, "Allowance exceeded");
        }
        balanceOf[from] -= value;
        balanceOf[to] += value;
        if (from != msg.sender) {
            _allowances[from][msg.sender] -= value;
        }
        emit Transfer(from, to, value);
        return true;
    }
}