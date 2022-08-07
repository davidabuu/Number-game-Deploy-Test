const { assert } = require("chai");
const { network, deployments, getNamedAccounts, ethers } = require("hardhat");
const { developmentChains } = require("../helper-config");

!developmentChains.includes(network.name)
  ? describe.skip()
  : describe("Game Unit Testing", async () => {
      //Global Variables
      let deployer, vrfCoordinatorV2Mock, entranceFee, gameMock;
      beforeEach("Game Testing", async () => {
        deployer = (await getNamedAccounts()).deployer;
        //console.log(deployer);
        await deployments.fixture(["all"]);
        gameMock = await ethers.getContract("NumberGuessingGame", deployer);
        entranceFee = await gameMock.getEntranceFee();
      });
      describe("Enter The Game", async () => {
        it("Allow a player to be recorded ", async () => {
          const gameContract = await gameMock.getEntranceFee();
          await gameMock.enterGame({ value: entranceFee });
          const totalPlayers = await gameMock.totalNumberOfPlayers();
          assert.equal(totalPlayers.toString(), "1");
        });
      });
    });
