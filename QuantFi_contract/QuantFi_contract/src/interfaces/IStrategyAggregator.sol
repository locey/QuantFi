// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IStrategyAggregator {
    // 代币金库存款
    function deposit(address _token, uint256 _amount) external;
    // 代币金库取款
    function withdraw(address _token, uint256 _amount) external;
}
