// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {SimpleStorage} from "./SimpleStorage.sol";
import {Test} from "forge-std/Test.sol";

contract SimpleStorageTest is Test {
  SimpleStorage simpleStorage;
  
  function setUp() public {
    simpleStorage = new SimpleStorage();
  }
  
  function test_InitialValue() public view {
    require(simpleStorage.myNumber() == 0, "Initial value should be 0");
  }
  
  function test_SetNumber() public {
    simpleStorage.setNumber(777);
    require(simpleStorage.getNumber() == 777, "Should be 777");
  }
  
  function testFuzz_SetNumber(uint256 x) public {
    simpleStorage.setNumber(x);
    require(simpleStorage.getNumber() == x, "Should match");
  }
}