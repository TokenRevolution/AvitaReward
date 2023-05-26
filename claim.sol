pragma solidity ^0.8.0;
//"SPDX-License-Identifier: UNLICENSED
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TransferReward {
    address public owner;
    address public avitaToken;
    uint256 public lastClaimTime;

    event Claim(address indexed from, uint256 amount);

    constructor(address _avitaToken) {
        owner = msg.sender;
        avitaToken = _avitaToken;
        lastClaimTime = block.timestamp;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    function claim(uint256 _claimAmount) external {
        require(block.timestamp >= lastClaimTime + 30 days, "Can only claim once per month");
        require(_claimAmount > 0, "Amount must be greater than zero");

        uint256 balance = IERC20(avitaToken).balanceOf(owner);
        require(balance >= _claimAmount, "Insufficient balance in the owner's wallet");

        require(IERC20(avitaToken).transfer(msg.sender, _claimAmount), "Token transfer failed");
        lastClaimTime = block.timestamp;

        emit Claim(msg.sender, _claimAmount);
    }

    function updateOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid owner address");
        owner = _newOwner;
    }
}
