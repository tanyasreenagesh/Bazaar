import "@nomiclabs/hardhat-waffle";
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
  }
};

export default config;
