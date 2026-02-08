// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Governor
 * @dev Simple governance contract for DAO decision making.
 */
contract Governor {
    enum ProposalState { Pending, Active, Defeated, Succeeded, Executed }

    struct Proposal {
        address proposer;
        string description;
        uint256 voteFor;
        uint256 voteAgainst;
        uint256 startTime;
        uint256 endTime;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    uint256 public proposalCount;
    uint256 public constant VOTING_PERIOD = 3 days;

    event ProposalCreated(uint256 id, address proposer, string description);
    event VoteCast(address indexed voter, uint256 proposalId, bool support);
    event ProposalExecuted(uint256 id);

    function propose(string memory _description) external returns (uint256) {
        proposalCount++;
        uint256 id = proposalCount;

        proposals[id] = Proposal({
            proposer: msg.sender,
            description: _description,
            voteFor: 0,
            voteAgainst: 0,
            startTime: block.timestamp,
            endTime: block.timestamp + VOTING_PERIOD,
            executed: false
        });

        emit ProposalCreated(id, msg.sender, _description);
        return id;
    }

    function castVote(uint256 _proposalId, bool _support) external {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp <= p.endTime, "Voting ended");
        require(!hasVoted[_proposalId][msg.sender], "Already voted");

        if (_support) {
            p.voteFor++;
        } else {
            p.voteAgainst++;
        }

        hasVoted[_proposalId][msg.sender] = true;
        emit VoteCast(msg.sender, _proposalId, _support);
    }

    function execute(uint256 _proposalId) external {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp > p.endTime, "Voting still active");
        require(p.voteFor > p.voteAgainst, "Proposal did not pass");
        require(!p.executed, "Already executed");

        p.executed = true;
        emit ProposalExecuted(_proposalId);
        
        // In a real DAO, this would trigger a low-level call to a target contract
    }

    function state(uint256 _proposalId) public view returns (ProposalState) {
        Proposal storage p = proposals[_proposalId];
        if (p.executed) return ProposalState.Executed;
        if (block.timestamp <= p.endTime) return ProposalState.Active;
        if (p.voteFor > p.voteAgainst) return ProposalState.Succeeded;
        return ProposalState.Defeated;
    }
}
