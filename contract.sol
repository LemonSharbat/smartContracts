// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Crowdfunding {
    string public name;
    string public description;
    uint256 public goal;  // Money
    uint256 public deadline;
    address public owner;

    struct Tier {
        string name;
        uint256 amount;
        uint256 backers;  //No of Tiers?
    }

    Tier[] public tiers; //Array of Tiers(structure)

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(
        string memory _name,
        string memory _description,
        uint256 _goal,
        uint256 _durationInDays) {
            name = _name;
            description = _description;
            goal = _goal;
            deadline = block.timestamp +(_durationInDays * 1 days); 
              // Deadline = current time + specified no. of days
            owner = msg.sender;
    }

    function fund(uint256 _tierIndex) public payable {
        require(block.timestamp < deadline, "Sorry! The campaign has ended.");
        require(_tierIndex < tiers.length, "Invalid tier");
        require(msg.value == tiers[_tierIndex].amount,"Incorrect amount");

        tiers[_tierIndex].backers++;
        }

    function addTier(
        string memory _name,
        uint256 _amount) public onlyOwner {
            require(_amount > 0, "Amount must be greater than ZERO");
            tiers.push(Tier(_name, _amount, 0));
    }

    function removeTier(uint256 _index) public onlyOwner {
        require(_index < tiers.length, "Tier does not exists");
        tiers[_index] = tiers[tiers.length -1];   // Didn't understand this?!
        tiers.pop();

    }

    function withdraw() public onlyOwner {
        require(address(this).balance >= goal, "Goal had not been reached.");
          // address(this).balance -> balance in 'this'(Crowdfunding) smart contract

        uint256 balance = address(this).balance;
        require(balance > 0, "No balence to withrow");

        payable(owner).transfer(balance);
        //transfer the balence from the locked smart contract to the owner(fundraiser)
        
    }

    function getContractBalance() public view returns(uint256) {
        return address(this).balance;
    }
}
