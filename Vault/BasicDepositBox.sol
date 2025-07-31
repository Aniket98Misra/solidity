// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "./Ownable.sol";
import "./IsSafeDepositBox.sol";


contract BasicDepositBox is Ownable, ISafeDepositBox {
   
    string private secret;

   
    constructor(address _initialOwner, address _vaultManager) Ownable(_initialOwner, _vaultManager) {
        // initial owner is set by ownable constructor
    }

   
    function storeSecret(address _originalSender, string memory _secret) external override onlyAllowedCaller(_originalSender) {
        secret = _secret;
    }

   
    function getSecret(address _originalSender) external view override onlyAllowedCaller(_originalSender) returns (string memory) {
        return secret;
    }

    function getOwner() public view override(Ownable, ISafeDepositBox) returns (address) {
        // Call Ownable's public getOwner function
        return Ownable.getOwner();
    }

    
    function transferOwnership(address _originalSender, address _newOwner) public override(Ownable, ISafeDepositBox) onlyAllowedCaller(_originalSender) {
        // Call the internal function directly to bypass Ownable's specific modifier logic on the public function
        Ownable.transferOwnership(_originalSender, _newOwner);
    }
}