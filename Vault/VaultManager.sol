// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IsSafeDepositBox.sol";
import "./BasicDepositBox.sol";


contract VaultManager {
   
    mapping(address => address[]) public userBoxes;

    
    address[] public allBoxes;

    
    event BoxCreated(address indexed owner, address indexed boxAddress, string boxType);

    
    function createBasicDepositBox() external returns (address newBoxAddress) {
        // Pass msg.sender as owner and address(this) as the trusted VaultManager
        BasicDepositBox newBox = new BasicDepositBox(msg.sender, address(this));
        newBoxAddress = address(newBox);

        // Add the new box to the state
        userBoxes[msg.sender].push(newBoxAddress);
        allBoxes.push(newBoxAddress);

        // Emit event
        emit BoxCreated(msg.sender, newBoxAddress, "BasicDepositBox");
    }

    
    function getMyBoxes() external view returns (address[] memory) {
        return userBoxes[msg.sender];
    }

   
    function getSecretFromBox(address _boxAddress) external view returns (string memory) {
        require(_boxAddress != address(0), "VaultManager: Invalid box address");
        ISafeDepositBox box = ISafeDepositBox(_boxAddress);
        // Pass msg.sender as the original caller
        return box.getSecret(msg.sender);
    }

    /**
     * @notice Stores a secret in a specific deposit box via delegation.
     * @param _boxAddress The address of the deposit box contract
     * @param _secret The secret string to store
     */
    function storeSecretInBox(address _boxAddress, string memory _secret) external {
        require(_boxAddress != address(0), "VaultManager: Invalid box address");
        ISafeDepositBox box = ISafeDepositBox(_boxAddress);
        // Pass msg.sender as the original caller
        box.storeSecret(msg.sender, _secret);
    }

   
    function transferBoxOwnership(address _boxAddress, address _newOwner) external {
        require(_boxAddress != address(0), "VaultManager: Invalid box address");
        require(_newOwner != address(0), "VaultManager: Invalid new owner address");
        
        ISafeDepositBox box = ISafeDepositBox(_boxAddress);
        address currentOwner = msg.sender; // This is the original user initiating the transfer

        // Call transfer ownership on the box contract itself, passing the original caller
        box.transferOwnership(currentOwner, _newOwner);

        // update the mapping (logic remains the same as before)
        // Remove from the current owner's list
        address[] storage currentOwnerBoxes = userBoxes[currentOwner];
        uint256 boxIndex = type(uint256).max;
        for (uint256 i = 0; i < currentOwnerBoxes.length; i++) {
            if (currentOwnerBoxes[i] == _boxAddress) {
                boxIndex = i;
                break;
            }
        }

        assert(boxIndex != type(uint256).max);
        
        currentOwnerBoxes[boxIndex] = currentOwnerBoxes[currentOwnerBoxes.length - 1];
        currentOwnerBoxes.pop();
        userBoxes[currentOwner] = currentOwnerBoxes;
        userBoxes[_newOwner].push(_boxAddress);
    }
}