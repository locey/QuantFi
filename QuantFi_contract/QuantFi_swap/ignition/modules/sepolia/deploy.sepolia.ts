import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const usdcAddress = "0x1c7d4b196cb0c7b01d743fbc6116a902379c7238"; // USDC address on Sepolia testnet
const maxHops = 4; // Default maximum number of hops
const deployer = process.env.DEPLOYER_ADDRESS || ""; // Replace with actual deployer address

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

export default buildModule("TokenSwapModule", (m) => {

  const account = m.getAccount(0)

  const PathFinder = m.contract("PathFinder", [
    usdcAddress,
    maxHops,
    account
  ]);

  const TokenSwap = m.contract("TokenSwap", [
    PathFinder,
    account
  ]);

  m.call(PathFinder, "transferOwnership", [TokenSwap], {id: "transferPathFinderOwnership"});
  m.call(TokenSwap, "setMaxHops", [4], {id: "setMaxHops"});
  m.call(TokenSwap, "setTargetToken", [usdcAddress], {id: "setTargetToken"});

  const UniswapV3Router = m.contract("UniswapV3Router", [
    uniswapV3SwapRouterAddress,
    uniswapV3QuoterV2Address,
    uniswapV3FactoryAddress,
    account,
    WETH9,
    exchangeTokens
  ]);

  for (let i = 0; i < exchangeTokens.length - 1; i++) {
    const tokenA = exchangeTokens[i];
    for (let j = i + 1; j < exchangeTokens.length; j++) {
      const tokenB = exchangeTokens[j];
      m.call(UniswapV3Router, "setFeeTier", [tokenA, tokenB, 3000], {id: `id_${tokenA}_${tokenB}_3000`});
    }
    m.call(UniswapV3Router, "setFeeTier", [tokenA, usdcAddress, 3000], {id: `id_${tokenA}_${usdcAddress}_3000`});
  }
  m.call(TokenSwap, "addDexRouter", ["uniswapV3", UniswapV3Router], {id: "addUniswapV3Router"});

  return { PathFinder, TokenSwap, UniswapV3Router };
});