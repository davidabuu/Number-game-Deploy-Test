const { network, ethers } = require("hardhat");
const fs = require("fs");
const FRONT_END_ADDRESSES_FILE =
  "../next-lottery/constants/contractAddress.json";
const FRONT_END_ABI_FILE = "./constant/abi.json";
module.exports = async function () {
  if (process.env.UPDATEFRONTEND) {
    console.log("Updating FrontEnd");
    // updateContractAddress();
   // updateAbi();
  }
  async function updateAbi() {
    const raffle = await ethers.getContract("NumberGuessingGame");
    fs.writeFileSync(
  
      FRONT_END_ABI_FILE,
      raffle.interface.format(ethers.utils.FormatTypes.json)
    );
    console.log('Working')
  }
  updateAbi()
};


// async function updateContractAddress() {
//   const raffle = await ethers.getContract("Raffle");
//   const contractAddresses = fs.readFileSync(FRONT_END_ADDRESSES_FILE, "utf8");
//   if (network.config.chainId in contractAddresses) {
//     if (!contractAddresses[network.config.chainId].includes(raffle.address)) {
//       contractAddresses[network.config.chainId].push(raffle.address);
//     }
//   } else {
//     contractAddresses[network.config.chainId] = [raffle.address];
//   }
//   fs.writeFileSync(FRONT_END_ADDRESSES_FILE, JSON.stringify(contractAddresses));
// }

 module.exports.tags = ["all", "frontend"];
