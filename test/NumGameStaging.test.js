// const { assert } = require("chai");
// const { network, getNamedAccounts, deployments, ethers } = require("hardhat");
// const { developmentChains } = require("../helper-config");

// developmentChains.includes(network.name)
//   ? describe.skip()
//   : describe('RinkeBy Game Test', async () => {
//      let deployer, entranceFee, gameMock;
//       beforeEach(async () => {
//         beforeEach("Game Test", async () => {
//           deployer = (await getNamedAccounts()).deployer;
//           gameMock = await ethers.getContract("NumberGuessingGame", deployer);
//           console.log(deployer);
//           entranceFee = await gameMock.getEntranceFee();
//         });
//         describe("Get entrance Fee", async () => {
//           it("Check the entrance Fee", async () => {
//             assert.equal(
//               entranceFee.toString(),
//               ethers.utils.parseEther("0.01")
//             );
//           });
//         });
//       });
//     });
