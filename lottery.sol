// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery{
    // manager of lottery 
    address public manager;

    // array of participants coz there will be more than one participants 
    address payable[] public participants;

    constructor(){
        // giving control of this contract to the manager
        // global variable is msg.sender 
        manager=msg.sender;
    }
    // sending amount to contract 
    // we will use receive function 
    // This function is executed when the contract receives Ether.
    // It's often used to handle incoming payments or transactions.

    receive() external payable {
        // setting least price as 1 ether 
        require(msg.value==1 ether);

        participants.push(payable(msg.sender));
     }

     // function to get balance of this contract 
     function getbalance() public view returns(uint){
        // show balance only if manager is checking 
        require(msg.sender==manager);
        return address(this).balance;
     }

     // selecting random number  
     function random() public view returns(uint){
         return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participants.length)));
     }

     //selecting actual winner 

     function selectWinner() public {

        require(msg.sender==manager);
        require(participants.length>=3);
        uint r=random();
        address payable winner;
        uint index=r%participants.length;
        winner =participants[index];
        winner.transfer(getbalance());

        // reseting out contract 
        participants=new address payable [](0);
     }
}