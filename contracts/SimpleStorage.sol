// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract SimpleStorage {
  uint public myNumber;
  
  event NumberChanged(uint oldNumber, uint newNumber);
  
  function setNumber(uint _num) public {
    uint oldNum = myNumber;
    myNumber = _num;
    emit NumberChanged(oldNum, _num);
  }
  
  function getNumber() public view returns (uint) {
    return myNumber;
  }
}