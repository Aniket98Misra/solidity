// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Ownable.sol";


contract VaultMaster is Ownable {
   
    event Deposited(address indexed from, uint256 indexed amount);

   
    event Withdrew(address indexed to, uint256 indexed amount);

   
    error InsufficientFunds(uint256 requested, uint256 available);

    constructor() Ownable() {}

    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    fallback() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function withdraw(address payable _to, uint256 _amount) external onlyOwner {
        require(_to != address(0), "invalid withdrawal address");

        // check amount
        require(_amount > 0, "withdrawal amount must be greater than 0");
        if (_amount > address(this).balance) {
            revert InsufficientFunds(_amount, address(this).balance);
        }

        // transfer amount
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "ETH transfer failed");

        // emit event
        emit Withdrew(_to, _amount);
    }
}