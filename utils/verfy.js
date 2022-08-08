const { run } = require("hardhat");

const verify = async (contractAddress, args) => {
  console.log("Verfying Address");
  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    });
  } catch (error) {
    if (error.message.toLowerCase().includes("already verified")) {
      console.log("Verified");
    } else {
      console.log(error);
    }
  }
};

module.exports = {
  verify,
};
