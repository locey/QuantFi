import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import pathfinder from "./PathFinderModule.js";

const usdcAddress = "0x1c7d4b196cb0c7b01d743fbc6116a902379c7238"; // USDC address on Sepolia testnet

export default buildModule("TokenSwapModule", (m) => {
  const PathFinderModule = m.useModule(pathfinder);
  
  // 获取部署者账户
  const account = m.getAccount(0);

  // 部署TokenSwap合约
  const TokenSwap = m.contract("TokenSwap", [
    PathFinderModule.PathFinder,
    account
  ]);

  // 将PathFinder的所有权转移给TokenSwap
  const call1 = m.call(PathFinderModule.PathFinder, "transferOwnership", [TokenSwap], {id: "transferPathFinderOwnership"});
  // 设置TokenSwap参数
  m.call(TokenSwap, "setMaxHops", [4], {id: "setMaxHops", after: [call1]});
  m.call(TokenSwap, "setTargetToken", [usdcAddress], {id: "setTargetToken", after: [call1]});

  
  return { TokenSwap };
});
