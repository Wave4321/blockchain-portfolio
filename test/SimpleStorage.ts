import { expect } from "chai";
import { network } from "hardhat";

const { ethers } = await network.connect();

describe("SimpleStorage", function () {
  
  it("Should store and retrieve a number", async function () {
    const storage = await ethers.deployContract("SimpleStorage");
    
    await storage.setNumber(777);
    expect(await storage.getNumber()).to.equal(777n);
  });
  
  it("Should emit NumberChanged event", async function () {
    const storage = await ethers.deployContract("SimpleStorage");
    
    await expect(storage.setNumber(999))
      .to.emit(storage, "NumberChanged")
      .withArgs(0n, 999n);
  });
  
  it("Should track multiple changes", async function () {
    const storage = await ethers.deployContract("SimpleStorage");
    const deploymentBlockNumber = await ethers.provider.getBlockNumber();
    
    await storage.setNumber(100);
    await storage.setNumber(200);
    await storage.setNumber(300);
    
    const events = await storage.queryFilter(
      storage.filters.NumberChanged(),
      deploymentBlockNumber,
      "latest",
    );
    
    expect(events.length).to.equal(3);
    
    const lastEvent = events[events.length - 1];
    expect(lastEvent.args.oldNumber).to.equal(200n);
    expect(lastEvent.args.newNumber).to.equal(300n);
  });
});