//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InventoryPlugin {
    mapping(address => mapping(uint256 => uint256)) public inventoryItems;

    event ItemAdded(address indexed player, uint256 indexed itemId, uint256 quantity, uint256 newBalance);
    event ItemRemoved(address indexed player, uint256 indexed itemId, uint256 quantity, uint256 newBalance);
    
    error InsufficientBalance(address player, uint256 itemId, uint256 requested, uint256 available);

    function addItem(uint256 _itemId, uint256 _quantity) external {
        require(_quantity > 0, "Quantity must be greater than zero");
        address player = msg.sender;
        uint256 currentBalance = inventoryItems[player][_itemId];
        uint256 newBalance = currentBalance + _quantity;
        inventoryItems[player][_itemId] += _quantity;
        emit ItemAdded(player, _itemId, _quantity, newBalance);
    }

    function removeItem(uint256 _itemId, uint256 _quantity) external {
        require(_quantity > 0, "Quantity must be greater than zero");
        address player = msg.sender;
        uint256 currentBalance = inventoryItems[player][_itemId];
        if (currentBalance < _quantity) {
            revert InsufficientBalance(player, _itemId, _quantity, currentBalance);
        }
        uint256 newBalance = currentBalance - _quantity;
        inventoryItems[player][_itemId] = newBalance;
        emit ItemRemoved(player, _itemId, _quantity, newBalance);
    }

    function getItemBalance(address _player, uint256 _itemId) external view returns (uint256) {
        return inventoryItems[_player][_itemId];
    }
}