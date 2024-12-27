// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface AggregatorV3Interface {
    function latestAnswer() external view returns (int256);
}

contract USDTClone {
    string public constant name = "Tether USD";
    string public constant symbol = "USDT";
    uint8 public constant decimals = 6;
    uint256 public totalSupply;

    mapping(address => uint256) private balances;
    address public owner;

    AggregatorV3Interface private priceFeed;
    uint256 public currentPrice;
    string public tokenLogoURI;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event PriceUpdated(uint256 newPrice);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    constructor(
        uint256 _totalSupply,
        string memory _logoURI
    ) {
        owner = msg.sender;
        totalSupply = _totalSupply * (10 ** uint256(decimals));
        balances[owner] = totalSupply;
        tokenLogoURI = _logoURI;
        currentPrice = 1000000; // Цена по умолчанию (1 USDT = $1.00)
    }

    function updatePrice(uint256 _newPrice) public onlyOwner {
        currentPrice = _newPrice;
        emit PriceUpdated(currentPrice);
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function getLogoURI() public view returns (string memory) {
        return tokenLogoURI;
    }
}
