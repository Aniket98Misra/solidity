// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


contract VotingSystem {
  
    struct Proposal {
        string name;
        uint256 voteCount;
        mapping(address => bool) hasVoted;
    }

    address public owner;
    Proposal[] private proposals;
    mapping(address => bool) public approvedVoters;

    error NotAllowed();
    error InvalidProposal();
    error AlreadyVoted();

   
    event ProposalAdded(uint256 indexed proposalId, string name);
    
    
    event VoterApproved(address indexed voter);

    
    event Voted(address indexed voter, uint256 indexed proposalId);

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotAllowed();
        _;
    }

    modifier onlyApproved() {
        if (!approvedVoters[msg.sender]) revert NotAllowed();
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    
    function addProposal(string calldata name) external onlyOwner {
        Proposal storage p = proposals.push();
        p.name = name;
        emit ProposalAdded(proposals.length - 1, name);
    }


    function approveVoter(address voter) external onlyOwner {
        approvedVoters[voter] = true;
        emit VoterApproved(voter);
    }

   e(uint256 proposalId) external onlyApproved {
        if (proposalId >= proposals.length) revert InvalidProposal();

        Proposal storage p = proposals[proposalId];
        if (p.hasVoted[msg.sender]) revert AlreadyVoted();
        
        p.hasVoted[msg.sender] = true;
        p.voteCount++;
        emit Voted(msg.sender, proposalId);
    }

  
    function proposalCount() external view returns (uint256 count) {
        return proposals.length;
    }

    function getProposal(uint256 proposalId) external view returns (string memory name, uint256 voteCount) {
        if (proposalId >= proposals.length) revert InvalidProposal();
        Proposal storage p = proposals[proposalId];
        return (p.name, p.voteCount);
    }

    
    function hasVoted(uint256 proposalId, address user) external view returns (bool voted) {
        if (proposalId >= proposals.length) revert InvalidProposal();
        return proposals[proposalId].hasVoted[user];
    }
}