const { network } = require("hardhat");
const subscriptionId = 2673
module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
 
    log("Deploying......");
    await deploy("NumberGuessingGame", {
      from: deployer,
      args:[subscriptionId],
      waitConfirmations: network.config.blockConfirmation || 1,
      log:true,
    });
  //  console.log(res)
    log("---------------------------------");
  
};

module.exports.tags = ["all", "mock"];
