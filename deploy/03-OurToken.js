const { ethers } = require("hardhat");

const initalSupply = ethers.utils.parseEther("0.01");
module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployer } = await getNamedAccounts();
  const { deploy, log } = deployments;
  log("--------Token Detected");
  await deploy("OurToken", {
    from: deployer,
    args: [initalSupply],
    waitConfirmations: 1,
    log: true,
  });
  log("----------------Token Deployed");
};

module.exports.tags = ["all", "OurToken"];
