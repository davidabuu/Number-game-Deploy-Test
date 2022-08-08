require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("hardhat-deploy");
require("solidity-coverage");
require("hardhat-gas-reporter");
require("hardhat-contract-sizer");
require("dotenv").config();

//Get The Environmental Variables
const RINKEBY_URL = process.env.RINKEBY_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ETHERSCAN = process.env.API_URL_KEY;
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
      blockConfirmations: 1,
    },
    rinkeby: {
      chainId: 4,
      url: RINKEBY_URL,
      accounts: [PRIVATE_KEY],
      blockConfirmations: 6,
    },
  },
  etherscan: {
    apiKey: ETHERSCAN,
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    player: {
      default: 1,
    },
  },
};
