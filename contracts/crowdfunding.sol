// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdFund {
    address public owner;
    uint256 public goal;
    uint256 public totalFunds;

    mapping(address => uint256) public contributions;

    constructor(uint256 _goal) {
        owner = msg.sender;
        goal = _goal;
    }

    // Function 1: Allow users to contribute ETH
    function contribute() external payable {
        require(msg.value > 0, "Must send ETH to contribute");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }
    // Function 2: Allow the owner to withdraw funds if goal is reached
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= goal, "Goal not reached yet");
        payable(owner).transfer(address(this).balance);
    }

    // Function 3: Get current contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
