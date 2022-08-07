const { network, ethers } = require("hardhat");
const { developmentChains, networkConfig } = require("../helper-config");
const { verify } = require("../utils/verfy");
const FUND_AMOUNT = ethers.utils.parseEther("2");
module.exports = async ({ deployments, getNamedAccounts }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  console.log(deploy, log, deployer)
  const chainId = network.config.chainId;
  let vrfCoordinatiorV2Address, subscriptionId;
  if (developmentChains.includes(network.name)) {
    const vrfCoordinatiorV2Contract = await ethers.getContract(
      "VRFCoordinatorV2Mock"
    );
    vrfCoordinatiorV2Address = vrfCoordinatiorV2Contract.address;
    const transactionResponse =
      await vrfCoordinatiorV2Contract.createSubscription();
    const transactionReceipt = await transactionResponse.wait(1);
    subscriptionId = transactionReceipt.events[0].args.subId;
    await vrfCoordinatiorV2Contract.fundSubscription(
      subscriptionId,
      FUND_AMOUNT
    );
  } else {
    vrfCoordinatiorV2Address = networkConfig[chainId]["vrfCoordinatiorV2"];
  }
  let entranceFee = networkConfig[chainId]["entranceFee"];
  let gasLane = networkConfig[chainId]["gasLane"];
  const args = [vrfCoordinatiorV2Address, entranceFee, gasLane, subscriptionId];
  const game = await deploy("NumberGuessingGame", {
    from: deployer,
    args,
    log: true,
    waitConfirmations: network.config.blockConfirmation || 1,
  });
  if (!developmentChains.includes(network.name) && process.env.API_URL_KEY) {
    log("Verfying");
    await verify(game.address, args);
  }
  log("-----------------------------------");
};

module.exports.tags = ["all", "game"];
