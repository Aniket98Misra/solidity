// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AchievementsPlugin {
    mapping(address => mapping(uint256=>bool)) public Achievements;

    event AchievementUnlocked(address indexed user, uint256 indexed achievementId);

    function unlockAchievement(uint256 _achievementId) public {
        address player = msg.sender;
        if (!Achievements[player][_achievementId]) {
            Achievements[player][_achievementId] = true;
            emit AchievementUnlocked(player, _achievementId);
        }
    }

    function hasAchievement(address _player, uint256 _achievementId) external view returns (bool) {
        return Achievements[_player][_achievementId];
    }
}