import {expect} from "chai";
import { network } from "hardhat";

const { ethers } = await network.connect();

const usdcAddress = "0x1c7d4b196cb0c7b01d743fbc6116a902379c7238"; // USDC address on Sepolia testnet
const maxHops = 4; // Default maximum number of hops
// const deployer = process.env.DEPLOYER_ADDRESS || ""; // Replace with actual deployer address

// SwapRouter02(https://github.com/Uniswap/swap-router-contracts/blob/main/contracts/SwapRouter02.sol) 
// 0x3bFA4769FB09eefC5a80d6E87c3B9C650f7Ae48E
const uniswapV3SwapRouterAddress = "0x3bFA4769FB09eefC5a80d6E87c3B9C650f7Ae48E";
const uniswapV3QuoterV2Address = "0xEd1f6473345F45b75F8179591dd5bA1888cf2FB3";
const uniswapV3FactoryAddress = "0x0227628f3F023bb0B980b67D528571c95c6DaC1c";
// btc: 0x66194f6c999b28965e0303a84cb8b797273b6b8b
// DAI: 0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357
// UNI: 0x1f9840a85d5af5bf1d1762f925bdaddc4201f984
// OKB: 0x3F4B6664338F23d2397c953f2AB4Ce8031663f80
const exchangeTokens = ["0x66194f6c999b28965e0303a84cb8b797273b6b8b", "0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357", "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984", "0x3F4B6664338F23d2397c953f2AB4Ce8031663f80"];
const WETH9 = "0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14"; // WETH9 address on Sepolia testnet

async function main() {
  const deployer = (await ethers.getSigners())[0]

  
  const pathFinderAddress = "";
  const tokenSwapAddress = "";

  const pathFinder = await ethers.getContractAt("PathFinder", pathFinderAddress);
  const tokenSwap = await ethers.getContractAt("TokenSwap", tokenSwapAddress);

  await pathFinder.transferOwnership(tokenSwapAddress);
  await tokenSwap.setMaxHops(4);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
