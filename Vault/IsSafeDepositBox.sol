// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


interface ISafeDepositBox {
    
    function storeSecret(address _originalSender, string memory _secret) external;

    
    function getSecret(address _originalSender) external view returns (string memory);

    
    function getOwner() external view returns (address);

   
    function transferOwnership(address _originalSender, address newOwner) external;
}