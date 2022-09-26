const { network, ethers } = require("hardhat");
const { developmentChains } = require("../helper-config");
const BASE_FEE = ethers.utils.parseEther("0.25");
const GAS_PER_LINK = 1e9;
module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  //const args = [BASE_FEE, GAS_PER_LINK];
  if (developmentChains.includes(network.name)) {
    log("Local Mock Is Deteteced, Deploying......");
    await deploy("NumberGuessingGame", {
      from: deployer,
      args:[],
      waitConfirmations: network.config.blockConfirmation || 1,
    });
    log("Mock Deteced");
    log("---------------------------------");
  }
};

module.exports.tags = ["all", "mock"];
