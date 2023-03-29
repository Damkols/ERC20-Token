// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract ERC20 {
    // state variables these are stored permanently in the contract storage
    uint256 public totalSupply;
    string public name;
    string public symbol;

    //Events are a way for your contract to communicate that something happened on the blockchain to your app front-end, which can be 'listening' for certain events and take action when they happen.
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => uint256) public balanceOf;
    // Maps from the owner address to the spender address to the allowance value
    mapping(address =>  mapping(address => uint256)) public allowance;

    constructor(string memory name_, string memory symbol_){
        name = name_;
        symbol = symbol_;

        _mint(msg.sender, 100e18);
    }

// function decimals() public view returns (uint8)
// This is a cheaper way of declaring the decimals for of Token function
    function decimals() external pure returns (uint8) {
        return 18;
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        return _transfer(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        uint256 currentAllowance = allowance[sender][msg.sender];

        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        
        allowance[sender][msg.sender] = currentAllowance - amount;

        emit Approval(sender, msg.sender, allowance[sender][msg.sender]);

        return _transfer(msg.sender, recipient, amount);
    }

    //Allowance functions
    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "ERC20: transfer to the zero address");

        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;

    }

    function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = balanceOf[sender];

        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");

        balanceOf[sender] = senderBalance - amount;
        balanceOf[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        return true;
    }

    function _mint(address to, uint256 amount) internal {
        require((to != address(0)), "ERC20: mint to the zero address");

        totalSupply += amount;
        balanceOf[to] += amount;

        emit Transfer(address(0), to, amount);
    }
}