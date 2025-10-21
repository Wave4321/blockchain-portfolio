# SimpleStorage & Counter (Hardhat)

Hardhat 환경에서 Solidity를 학습하기 위해 만든 간단한 실습 프로젝트입니다.  

두 가지 컨트랙트가 포함되어 있습니다.
- **SimpleStorage**: 숫자를 저장하고 변경 시 이벤트를 발생시키는 간단한 컨트랙트  
- **Counter**: Hardhat 기본 예제 (증가/감소 로직)

---

## 프로젝트 개요
- Solidity 기본 문법과 이벤트 동작 구조를 익히기 위한 예제  
- Hardhat을 이용한 컴파일, 배포, 테스트 과정 실습  
- TypeScript 기반 테스트 코드 작성 연습  

---

## 테스트 내용
- 숫자 저장 및 조회 기능 확인  
- `NumberChanged` 이벤트 발생 검증  
- 여러 번 값 변경 시 이벤트 로그 확인  
- Counter 기본 동작 확인  

---

## 실행 방법

```bash
npm install
npx hardhat test
```

## 정리
Hardhat 기본 예제(Counter)를 바탕으로 환경을 익히고,
직접 작성한 SimpleStorage 컨트랙트를 추가해 Solidity의 기본 동작을 검증했습니다.
앞으로 다른 컨트랙트와 테스트를 더해가며 확장할 예정입니다.
