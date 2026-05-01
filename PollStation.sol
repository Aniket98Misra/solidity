// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PollStation {
    struct Candidate {
        bytes32 name;      // Gas: fixed size is significantly cheaper than string
        uint64 voteCount;  // Packable into a single storage slot
    }

    // Errors
    error CandidateIndexInvalid(uint256 index);
    error AlreadyVoted(address user);
    error NotVoted(address user);

    // Events
    event Voted(address indexed user, uint256 indexed candidateIndex);

    Candidate[] private candidates;
    
    // Mapping: Stores index + 1 (0 = Not Voted)
    mapping(address => uint256) private userVotes;

    // State Tracking: Eliminates the need for a for-loop
    uint256 public leadingCandidateIndex;
    uint64 public maxVotesCount;

    constructor() {
        // Use bytes32 literals. Strings < 32 chars fit perfectly.
        _addCandidate("Alice");
        _addCandidate("Bob");
        _addCandidate("Charlie");
    }

    // Internal helper to keep constructor clean
    function _addCandidate(bytes32 _name) internal {
        candidates.push(Candidate(_name, 0));
    }

    function vote(uint256 _index) external {
        // 1. Validation (Cheaper checks first)
        if (userVotes[msg.sender] != 0) revert AlreadyVoted(msg.sender);
        if (_index >= candidates.length) revert CandidateIndexInvalid(_index);

        // 2. Update storage (Bit-offset trick)
        userVotes[msg.sender] = _index + 1;
        
        // 3. Increment and Track Winner (The "Loop Killer")
        uint64 newVoteCount = candidates[_index].voteCount + 1;
        candidates[_index].voteCount = newVoteCount;

        if (newVoteCount > maxVotesCount) {
            maxVotesCount = newVoteCount;
            leadingCandidateIndex = _index;
        }

        emit Voted(msg.sender, _index);
    }

    // Constant time O(1) retrieval
    function getWinner() external view returns (bytes32 name, uint64 voteCount) {
        Candidate storage winner = candidates[leadingCandidateIndex];
        return (winner.name, winner.voteCount);
    }

    function getVote() external view returns (uint256) {
        uint256 voteData = userVotes[msg.sender];
        if (voteData == 0) revert NotVoted(msg.sender);
        return voteData - 1;
    }

    function getCandidatesCount() external view returns (uint256) {
        return candidates.length;
    }
}
