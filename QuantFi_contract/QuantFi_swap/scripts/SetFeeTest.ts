import { expect } from "chai";
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
// btc: 0x66194f6c999b28965e0303a84cb8b797273b6b8b --
// DAI: 0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357 --
// UNI: 0x1f9840a85d5af5bf1d1762f925bdaddc4201f984
// OKB: 0x3F4B6664338F23d2397c953f2AB4Ce8031663f80 --
// BYT: 0x7352cDBcA63F62358f08F6514d3B7fF2a2872AaD
// METH: 0x3eb804cd437c27f5aEB6Be7AbbB32D21a69Ca49e
const exchangeTokens = ["0x1f9840a85d5af5bf1d1762f925bdaddc4201f984", "0x7352cDBcA63F62358f08F6514d3B7fF2a2872AaD", "0x3eb804cd437c27f5aEB6Be7AbbB32D21a69Ca49e"];
const WETH9 = "0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14"; // WETH9 address on Sepolia testnet


async function main() {
  
  const uniswapV3Router = await ethers.getContractAt("UniswapV3Router", "0xD51ad52C537980334b9331eF498B3BA22FC67a01")

  // const tx = await uniswapV3Router.setFeeTier("0x66194f6c999b28965e0303a84cb8b797273b6b8b", "0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357", 3000);
  // error const tx = await uniswapV3Router.setFeeTier("0x66194f6c999b28965e0303a84cb8b797273b6b8b", "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984", 3000);
  // error const tx = await uniswapV3Router.setFeeTier("0x66194f6c999b28965e0303a84cb8b797273b6b8b", "0x3F4B6664338F23d2397c953f2AB4Ce8031663f80", 3000);
  // error const tx = await uniswapV3Router.setFeeTier("0x66194f6c999b28965e0303a84cb8b797273b6b8b", "0x1c7d4b196cb0c7b01d743fbc6116a902379c7238", 3000);
  // const tx = await uniswapV3Router.setFeeTier("0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357", "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984", 3000);
  // error const tx = await uniswapV3Router.setFeeTier("0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357", "0x3F4B6664338F23d2397c953f2AB4Ce8031663f80", 3000);
  // const tx = await uniswapV3Router.setFeeTier("0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357", "0x1c7d4b196cb0c7b01d743fbc6116a902379c7238", 3000);
  // error const tx = await uniswapV3Router.setFeeTier("0x1f9840a85d5af5bf1d1762f925bdaddc4201f984", "0x3F4B6664338F23d2397c953f2AB4Ce8031663f80", 3000);
  // const tx = await uniswapV3Router.setFeeTier("0x1f9840a85d5af5bf1d1762f925bdaddc4201f984", "0x1c7d4b196cb0c7b01d743fbc6116a902379c7238", 3000);
  
  // const tx1 = await uniswapV3Router.setFeeTier("0x1f9840a85d5af5bf1d1762f925bdaddc4201f984", "0x7352cDBcA63F62358f08F6514d3B7fF2a2872AaD", 3000);
  const tx = await uniswapV3Router.setFeeTier("0x1f9840a85d5af5bf1d1762f925bdaddc4201f984", "0x3eb804cd437c27f5aEB6Be7AbbB32D21a69Ca49e", 3000);
  
  
  console.log("Set fee tier tx1:", tx);
  const res = await tx.wait();
  console.log("Set fee tier tx1 mined:", res);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
