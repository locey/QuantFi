// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IDefiAdapter {
    // 返回操作类型是否支持
    function supportOperation(
        OperationType operationType
    ) external view virtual returns (bool);
    // 获取支持的操作类型
    function getSupportedOperations()
        external
        view
        virtual
        returns (uint256[] memory);
    // 执行操作
    function executeOperation(
        OperationParams calldata params,
        uint24 feeRate
    ) external virtual returns (OperationResult memory);
    // 获取适配器名称
    function getName() external view virtual returns (string memory);
    // 获取适配器版本
    function getVersion() external view virtual returns (string memory);
}

struct OperationParams {
    OperationType operationType;
    bytes data;
    address[] tokens;
    uint256[] amounts;
    address recipient;
    uint256 deadline;
    // NFT tokenId (用于 UniswapV3, Aave 等基于 NFT 的协议)
    uint256 tokenId;
    // 额外的操作特定数据
    bytes extraData;
}

struct OperationResult {
    uint256[] outputAmounts;
    bytes data;
    bool success;
    string message;
}

enum OperationType {
    //deposit
    DEPOSIT,
    //withdraw
    WITHDRAW,
    //添加流动性
    ADD_LIQUIDITY,
    //移除流动性
    REMOVE_LIQUIDITY,
    //提取手续费
    COLLECT_FEES,
    // 交换代币
    SWAP
}
