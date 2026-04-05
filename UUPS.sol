// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract FlexiBankV1 is OwnableUpgradeable, UUPSUpgradeable {
    mapping(address => uint256) public balances;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");
    }

    // This is the "Key" that allows future upgrades
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}

contract FlexiBankV2 is FlexiBankV1 {
    // DO NOT add new variables here yet. 
    // Just override the function logic.

    function withdraw(uint256 _amount) public override {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        
        uint256 fee = _amount / 100; // 1% Fee
        uint256 amountToUser = _amount - fee;

        balances[msg.sender] -= _amount;
        
        (bool success, ) = msg.sender.call{value: amountToUser}("");
        require(success, "Transfer failed");
        // Fee stays in the contract vault!
    }
}
