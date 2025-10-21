// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Voting {
  // 상태 변수 1: 누가 투표했는지 기록
  // mapping = 자료구조 (키 → 값)
  // address(키) → bool(값)
  // 예: 0xAlice주소 → true (투표함)
  mapping(address => bool) public hasVoted;
  
  // 📖 상태 변수 2: 각 후보자가 받은 표 수
  // string(후보자 이름) → uint(득표수)
  // 예: "Alice" → 5표
  mapping(string => uint) public votes;
  
  // 🔔 이벤트: 투표가 발생할 때마다 로그 기록
  // 프론트엔드에서 감지 가능
  event Voted(address indexed voter, string candidate);
  
  // 📝 메인 함수: 투표하기
  function vote(string memory candidate) public {
    // 1️⃣ 검증: 이미 투표했는지 확인
    // msg.sender = 이 함수를 호출한 사람의 주소
    // !hasVoted[msg.sender] = "아직 투표 안 함"이어야 통과
    require(!hasVoted[msg.sender], "Already voted");
    
    // 2️⃣ 기록: 이 사람 투표 완료로 표시
    hasVoted[msg.sender] = true;
    
    // 3️⃣ 집계: 후보자 득표수 +1
    votes[candidate]++;
    
    // 4️⃣ 이벤트 발생 (로그 기록)
    emit Voted(msg.sender, candidate);
  }
  
  // 📊 조회 함수: 특정 후보자의 득표수 확인
  // view = 상태 변경 안 함 (읽기만)
  // public이라 votes()로 자동 생성되지만 연습용으로 추가
  function getVotes(string memory candidate) public view returns (uint) {
    return votes[candidate];
  }
  
  // 🔍 조회 함수: 특정 주소가 투표했는지 확인
  function hasVotedAddress(address voter) public view returns (bool) {
    return hasVoted[voter];
  }
}