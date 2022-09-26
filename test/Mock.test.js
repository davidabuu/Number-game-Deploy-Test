const { assert, expect } = require("chai");
const { network, deployments, getNamedAccounts, ethers } = require("hardhat");
const { developmentChains } = require("../helper-config");

developmentChains.includes(network.name)
  ? describe.skip()
  : describe("Game Unit Testing", async () => {
      //Global Variables
      let deployer, vrfCoordinatorV2Mock, entranceFee, gameMock;
      beforeEach("Game Testing", async () => {
        deployer = (await getNamedAccounts()).deployer;
        //console.log(deployer);
        gameMock = await ethers.getContract("NumberGuessingGame", deployer);
        entranceFee = await gameMock.getEntranceFee();
      });
      describe("Enter The Game", async () => {
        it("Check if the entrance is set correctly", async () => {
          console.log(
            entranceFee.toString(),
            ethers.utils.parseEther("0.01").toString()
          );
          assert.equal(
            entranceFee.toString(),
            ethers.utils.parseEther("0.01").toString()
          );
        });
        // it("Fail because of low ether entered", async () => {
        //   await expect(gameMock.enterGame()).to.be.reverted;
        // });
        // it("Check if the VFR worked", async () => {
        //   const vrfResponse = await gameMock.requestRandomNumber([]);
        //   console.log(vrfResponse)
        //   // assert(requestId.toNumber() > 0);
        //   // const correctNumber = await gameMock.getCorrectNumber();
        //   // console.log("The correct Number is", correctNumber);
        // });
        // it("Performs The VRF", async () => {
        //   await new Promise(async (resolve, reject) => {
        //     gameMock.once("NumberPicked", async () => {
        //       console.log("Number Picked Event Fired");
        //       try {
        //         const getCorrectNumber = await gameMock.getCorrectNumber();
        //         console.log(getCorrectNumber);
        //       } catch (error) {
        //         reject(error);
        //       }
        //       resolve();
        //     });
        //     const vrfRandomWordResponse = await gameMock.requestRandomNumber(
        //       []
        //     );
        //     const vrfRandomWordResponseReciept =
        //       await vrfRandomWordResponse.wait(1);
        //     await gameMock.fulfillRandomWords(
        //       vrfRandomWordResponseReciept.events[1].args.requestId,
        //       gameMock.address
        //     );
        //   });
        // });
      });
      //Do all the function
    });
