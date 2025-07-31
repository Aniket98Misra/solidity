// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Ownable {
    address private owner;
    address public immutable vaultManagerAddress;

    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    
    error NotAllowed();

    
    constructor(address _initialOwner, address _vaultManager) {
        require(_initialOwner != address(0), "Ownable: initial owner is the zero address");
        require(_vaultManager != address(0), "Ownable: vault manager is the zero address");
        owner = _initialOwner;
        vaultManagerAddress = _vaultManager;
        emit OwnershipTransferred(address(0), _initialOwner);
    }

   
    function getOwner() public view virtual returns (address) {
        return owner;
    }

    
    modifier onlyOwner() {
        if (owner != msg.sender) {
            revert NotAllowed();
        }
        _;
    }

    modifier onlyAllowedCaller(address _originalSender) {
        if ((msg.sender != owner) && (msg.sender != vaultManagerAddress || _originalSender != owner)) {
            revert NotAllowed();
        }
        _;
    }

    
    function transferOwnership(address _originalSender, address _newOwner) public virtual onlyAllowedCaller(_originalSender) {
        require(_newOwner != address(0), "Ownable: new owner is the zero address");
        address oldOwner = owner;
        owner = _newOwner;
        emit OwnershipTransferred(oldOwner, _newOwner);
    }
}