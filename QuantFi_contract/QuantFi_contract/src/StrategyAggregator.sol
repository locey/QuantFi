// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./interfaces/IStrategyAggregator.sol";
import "./interfaces/IAssetsAdapter.sol";

contract StrategyAggregator is IStrategyAggregator, IAssetsAdapter {
    //存入
    function deposit(address _token, uint256 _amount) external override {}

    //取款
    function withdraw(address _token, uint256 _amount) external override {}

    //调用策略适配器执行真实资产注入
    function addAssets(address _token, uint256 _amount) external override {}

    //调用策略适配器执行真实资产取出
    function removeAssets(address _token, uint256 _amount) external override {}
}
