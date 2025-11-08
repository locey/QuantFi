// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;

library Model {
    // 存储潜在交换路径的结构体
    struct SwapPath {
        address[] path; // 代币地址数组表示的路径
        bytes pathBytes; // 路径字节表示
        uint256 outputAmount; // 输出金额
        uint256 inputAmount; // 输入金额
        address dexRouter; // 交易所路由地址
    }

}