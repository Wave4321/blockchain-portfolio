# Blockchain Portfolio

Hardhat 환경에서 Solidity를 학습하며 만든 스마트 컨트랙트 실습 프로젝트입니다.

## 프로젝트 개요

세 가지 컨트랙트를 통해 Solidity 기초부터 실전 개념까지 단계적으로 학습했습니다.

### Counter
Hardhat 기본 예제로 제공되는 컨트랙트입니다. 숫자를 증가시키는 간단한 로직을 통해 Hardhat 환경 사용법과 이벤트 동작을 익혔습니다.

### SimpleStorage ⭐
숫자를 저장하고 조회하는 기본 컨트랙트입니다. Solidity의 상태 변수, 함수, 이벤트 등 기본 문법을 익히기 위해 직접 작성했습니다.
- 숫자 저장 및 조회 기능
- 값 변경 시 `NumberChanged` 이벤트 발생
- 이벤트 히스토리 추적

### Voting ⭐
투표 시스템을 구현하며 실전에서 많이 쓰이는 개념들을 학습했습니다.
- 후보자별 득표수 관리
- 중복 투표 방지 로직
- 투표자 추적 기능

**새로 배운 개념:**
- `mapping`: 키-값 쌍으로 데이터를 저장하는 자료구조
- `msg.sender`: 함수를 호출한 사람의 주소를 식별
- `require()`: 조건을 검증하고 에러를 처리

## 기술 스택

- Solidity ^0.8.28
- Hardhat 3.0.7
- Ethers.js 6.x
- TypeScript
- Mocha & Chai

## 테스트

각 컨트랙트마다 Solidity와 TypeScript로 테스트를 작성했습니다.
- Solidity 테스트: 9개 (Fuzz 테스트 포함)
- TypeScript 테스트: 8개
- 총 17개 테스트 전부 통과
```bash
# 전체 테스트 실행
npx hardhat test

# 컴파일
npx hardhat compile
```

## 실행 방법
```bash
npm install
npx hardhat test
```

## 학습 진행 상황

**Week 1: Solidity 기초**
- Day 1: 환경 세팅 + SimpleStorage (변수, 함수, 이벤트)
- Day 2: Voting (mapping, msg.sender, require)
- Day 3-5: 토큰 기초 및 접근 제어 예정

## 다음 목표

- 토큰 시스템 구현 (ERC-20 기초)
- 접근 제어 패턴 학습
- 크라우드펀딩 플랫폼 (실전 프로젝트)
- Testnet 배포

## 정리

Hardhat 기본 예제(Counter)를 통해 환경을 익히고, SimpleStorage로 기초 문법을 다진 뒤, Voting 시스템으로 실전 개념을 학습했습니다. 앞으로 더 복잡한 컨트랙트와 테스트를 추가하며 확장해 나갈 예정입니다.
