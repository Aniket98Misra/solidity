// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;



contract ActivityTracker {
   
    mapping(address => mapping(string => uint)) private activityTargets;

    mapping(address => mapping(string => uint)) private activityUnits;

  
    event TargetSet(address indexed user, string indexed activity, uint indexed target);

 
    event ActivityRecorded(address indexed user, string indexed activity, uint indexed units);

    event TargetAchieved(address indexed user, string indexed activity, uint indexed target);

    error TargetNotSet(string activity);

    error TargetAlreadyReached(string activity, uint target);

    function getTarget(string calldata _activity) external view returns (uint) {
        return activityTargets[msg.sender][_activity];
    }
    function getUnits(string calldata _activity) external view returns (uint) {
        return activityUnits[msg.sender][_activity];
    }
    function setTarget(string calldata _activity, uint _target) external {
        activityTargets[msg.sender][_activity] = _target;
        emit TargetSet(msg.sender, _activity, _target);
    }
    function recordActivity(string calldata _activity, uint _units) external {
        require(_units > 0, "units must be greater than 0.");
        
        uint target = activityTargets[msg.sender][_activity];
        if (target == 0) {
            revert TargetNotSet(_activity);
        }
        
        uint oldUnits = activityUnits[msg.sender][_activity];
        if (oldUnits >= target) {
            revert TargetAlreadyReached(_activity, target);
        }

        activityUnits[msg.sender][_activity] += _units;

        emit ActivityRecorded(msg.sender, _activity, oldUnits);
        
        if (activityUnits[msg.sender][_activity] >= target) {
            emit TargetAchieved(msg.sender, _activity, target);
        }
    }
}
