// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Voting} from "./Voting.sol";
import {Test} from "forge-std/Test.sol";

contract VotingTest is Test {
  Voting voting;
  
  // setUp: 모든 테스트 전에 실행
  function setUp() public {
    voting = new Voting();
  }
  
  // ✅ 테스트 1: 초기 득표수는 0
  function test_InitialVotes() public view {
    require(voting.votes("Alice") == 0, "Initial votes should be 0");
    require(voting.votes("Bob") == 0, "Initial votes should be 0");
  }
  
  // ✅ 테스트 2: 투표 성공
  function test_Vote() public {
    // 투표 실행
    voting.vote("Alice");
    
    // 검증 1: Alice가 1표 받았나?
    require(voting.votes("Alice") == 1, "Alice should have 1 vote");
    
    // 검증 2: 내가 투표했다고 기록되었나?
    require(voting.hasVoted(address(this)), "Should be marked as voted");
  }
  
  // ✅ 테스트 3: 여러 명이 투표
  function test_MultipleVoters() public {
    // 첫 번째 투표 (이 컨트랙트가 투표)
    voting.vote("Alice");
    require(voting.votes("Alice") == 1, "Alice should have 1");
    
    // 두 번째 투표자 (다른 주소로)
    // vm.prank = 다음 호출을 다른 주소로 실행
    address voter2 = address(0x123);
    vm.prank(voter2);
    voting.vote("Alice");
    require(voting.votes("Alice") == 2, "Alice should have 2");
    
    // 세 번째 투표자
    address voter3 = address(0x456);
    vm.prank(voter3);
    voting.vote("Bob");
    require(voting.votes("Bob") == 1, "Bob should have 1");
  }
  
  // ✅ 테스트 4: 중복 투표 방지
  function test_CannotVoteTwice() public {
    // 첫 투표
    voting.vote("Alice");
    
    // 두 번째 투표 시도 → 실패 예상
    vm.expectRevert("Already voted");
    voting.vote("Bob");  // 이 줄에서 에러 발생해야 함
  }
  
  // ✅ 테스트 5: Fuzz 테스트 (랜덤 후보자 이름)
  function testFuzz_Vote(string memory candidate) public {
    // 어떤 이름이든 투표 가능해야 함
    voting.vote(candidate);
    require(voting.votes(candidate) == 1, "Should have 1 vote");
  }
  
  // ✅ 테스트 6: 이벤트 발생 확인
  function test_EmitEvent() public {
    // 이벤트 기대
    vm.expectEmit(true, false, false, true);
    emit Voting.Voted(address(this), "Alice");
    
    // 투표 실행
    voting.vote("Alice");
  }
}