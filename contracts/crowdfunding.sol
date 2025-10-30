// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Crowdfunding {
    address public owner;
    uint public goal;
    uint public deadline;
    uint public totalFunds;

    mapping(address => uint) public contributions;

    constructor(uint _goal, uint _durationInDays) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
    }

    // Function 1: Allow users to fund the campaign
    function contribute() external payable {
        require(block.timestamp < deadline, "Campaign has ended");
        require(msg.value > 0, "Contribution must be greater than 0");

        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }

    // Function 2: Allow owner to withdraw funds if goal reached
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(block.timestamp >= deadline, "Campaign still running");
        require(totalFunds >= goal, "Funding goal not reached");

        payable(owner).transfer(totalFunds);
    }

    // Function 3: Allow contributors to claim refund if goal not reached
    function refund() external {
        require(block.timestamp >= deadline, "Campaign still running");
        require(totalFunds < goal, "Goal was reached");

        uint contributedAmount = contributions[msg.sender];
        require(contributedAmount > 0, "No funds to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(contributedAmount);
    }

    // Function 4: View remaining time for the campaign
    function getTimeLeft() external view returns (uint) {
        if (block.timestamp >= deadline) {
            return 0;
        } else {
            return deadline - block.timestamp;
        }
    }

    // Function 5: View contract summary (for frontend use)
    function getSummary() external view returns (
        address _owner,
        uint _goal,
        uint _deadline,
        uint _totalFunds,
        bool _goalReached
    ) {
        _owner = owner;
        _goal = goal;
        _deadline = deadline;
        _totalFunds = totalFunds;
        _goalReached = totalFunds >= goal;
    }
}
