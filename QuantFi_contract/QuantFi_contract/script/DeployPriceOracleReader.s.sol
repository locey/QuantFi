// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/hyper/PerpPriceOracleReader.sol";
import "../src/hyper/CoreWriterCaller.sol";

contract DeployPriceOracleReader is Script {
    function run() external {
        // 开始广播以记录和发送交易
        vm.startBroadcast();

        // 部署 PriceOracleReader 合约
        TradingContract reader = new TradingContract();
        console.log("PriceOracleReader deployed at:", address(reader));

        // 结束广播
        vm.stopBroadcast();
    }
}
