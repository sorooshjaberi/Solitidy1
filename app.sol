// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
contract budget {
    address public owner;
 // remained time , remained money
    struct data{
        uint256 time;
        uint256 remain;
    }
// giving each staff a data 
    mapping (address=>data) staffs;
    // base money that is given to a staff
    uint256 baseMoney=10 ether;
// signing up 
 function createAccount() public {
     staffs[msg.sender].time=block.timestamp;
     staffs[msg.sender].remain=baseMoney;
 }
  
// view your status
function viewPortfolio() view public returns(uint256 , uint256) {
    require((staffs[msg.sender].time!=0),"problem");
     return ((staffs[msg.sender].time + 7 days - block.timestamp)/60/60/24, staffs[msg.sender].remain/1000000000000000000 );
}
constructor(){
     owner=msg.sender;
}

//only owner modifier
// modifier onlyOwner() {
//     require(msg.sender==owner,"not the owner");
//     _;
// }
modifier onlyOwner() {
        require(msg.sender==owner, "Not owner");
        _;
    }


//withdraw your salary
function withdraw(uint256 _wei) public  {
require(_wei <= staffs[msg.sender].remain/1000000000000000000,"not enough money");
staffs[msg.sender].remain-= _wei*1000000000000000000;
address payable to = payable(msg.sender);
to.transfer(_wei*1000000000000000000);
}
function deposit() public payable onlyOwner{

}
}