// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Ownable {
    address private owner;

    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    error NotAllowed();

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }

   
    function getOwner() external view returns (address) {
        return owner;
    }

    
    modifier onlyOwner() {
        if (owner != msg.sender) {
            revert NotAllowed();
        }
        _;
    }

  
    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "invalid new owner address");
        address oldOwner = owner;
        owner = _newOwner;
        emit OwnershipTransferred(oldOwner, _newOwner);
    }
}