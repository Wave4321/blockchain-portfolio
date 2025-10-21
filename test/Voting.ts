import { expect } from "chai";
import { network } from "hardhat";

const { ethers } = await network.connect();

describe("Voting", function () {
  
  // ✅ 테스트 1: 투표 및 득표수 확인
  it("Should vote for a candidate", async function () {
    const voting = await ethers.deployContract("Voting");
    
    // Alice에게 투표
    await voting.vote("Alice");
    
    // 검증: Alice가 1표 받았나?
    expect(await voting.votes("Alice")).to.equal(1n);
    expect(await voting.getVotes("Alice")).to.equal(1n);
  });
  
  // ✅ 테스트 2: 이벤트 발생 확인
  it("Should emit Voted event", async function () {
    const voting = await ethers.deployContract("Voting");
    
    // vote() 실행 시 Voted 이벤트 발생해야 함
    const [owner] = await ethers.getSigners();
    await expect(voting.vote("Bob"))
      .to.emit(voting, "Voted")
      .withArgs(owner.address, "Bob");
  });
  
  // ✅ 테스트 3: 중복 투표 방지
  it("Should prevent double voting", async function () {
    const voting = await ethers.deployContract("Voting");
    
    // 첫 투표
    await voting.vote("Alice");
    
    // 두 번째 투표 시도 → 실패해야 함
    await expect(voting.vote("Bob"))
      .to.be.revertedWith("Already voted");
  });
  
  // ✅ 테스트 4: 여러 계정 투표
  it("Should allow multiple accounts to vote", async function () {
    const voting = await ethers.deployContract("Voting");
    const [owner, addr1, addr2] = await ethers.getSigners();
    
    // owner 투표
    await voting.vote("Alice");
    expect(await voting.votes("Alice")).to.equal(1n);
    
    // addr1 투표
    await voting.connect(addr1).vote("Alice");
    expect(await voting.votes("Alice")).to.equal(2n);
    
    // addr2는 Bob에게 투표
    await voting.connect(addr2).vote("Bob");
    expect(await voting.votes("Bob")).to.equal(1n);
    
    // 최종 집계
    expect(await voting.votes("Alice")).to.equal(2n);
    expect(await voting.votes("Bob")).to.equal(1n);
  });
  
  // ✅ 테스트 5: 투표 여부 확인
  it("Should track who has voted", async function () {
    const voting = await ethers.deployContract("Voting");
    const [owner, addr1] = await ethers.getSigners();
    
    // 초기: 아무도 투표 안 함
    expect(await voting.hasVoted(owner.address)).to.be.false;
    expect(await voting.hasVoted(addr1.address)).to.be.false;
    
    // owner 투표
    await voting.vote("Alice");
    expect(await voting.hasVoted(owner.address)).to.be.true;
    expect(await voting.hasVoted(addr1.address)).to.be.false;
    
    // addr1 투표
    await voting.connect(addr1).vote("Bob");
    expect(await voting.hasVoted(owner.address)).to.be.true;
    expect(await voting.hasVoted(addr1.address)).to.be.true;
  });
  
  // ✅ 테스트 6: 이벤트 히스토리 조회
  it("Should track voting history via events", async function () {
    const voting = await ethers.deployContract("Voting");
    const [owner, addr1, addr2] = await ethers.getSigners();
    const deploymentBlock = await ethers.provider.getBlockNumber();
    
    // 여러 투표
    await voting.vote("Alice");
    await voting.connect(addr1).vote("Bob");
    await voting.connect(addr2).vote("Alice");
    
    // 모든 투표 이벤트 조회
    const events = await voting.queryFilter(
      voting.filters.Voted(),
      deploymentBlock,
      "latest"
    );
    
    // 검증
    expect(events.length).to.equal(3);
    expect(events[0].args.candidate).to.equal("Alice");
    expect(events[1].args.candidate).to.equal("Bob");
    expect(events[2].args.candidate).to.equal("Alice");
  });
});