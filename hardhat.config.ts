require('dotenv').config()

import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-etherscan"
import "@typechain/hardhat";
import "hardhat-deploy";
import { HardhatUserConfig } from "hardhat/config";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.4",
  },
  typechain: {
    outDir: "typechain"
  },
  namedAccounts: {
    deployer: 0
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY || ""
  },
  networks: {
    rinkeby: {
      url: process.env.MORALIS_RINKEBY_NODE_URL || "",
      accounts: [process.env.ACC1_PRIVATE_KEY || ""]
    }
  }
};

export default config;
