import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const usdcAddress = "0x1c7d4b196cb0c7b01d743fbc6116a902379c7238"; // USDC address on Sepolia testnet
const maxHops = 4; // Default maximum number of hops

export default buildModule("PathFinderModule", (m) => {
  // 获取部署者账户
  const account = m.getAccount(0);

  // 部署PathFinder合约
  const PathFinder = m.contract("PathFinder", [
    usdcAddress,
    maxHops,
    account
  ]);

  return { PathFinder };
});
