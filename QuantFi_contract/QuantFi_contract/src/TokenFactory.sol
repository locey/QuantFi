// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TokenFactory {
    //新增策略
    function addStrategy(address _token, address _strategy) external override {}
    //删除策略
    function removeStrategy(address _token) external override {}
    //获取策略地址
    function getStrategy(
        address _token
    ) external view override returns (address) {
        return address(0);
    }

    //获取策略数量
    function getStrategyCount() external view override returns (uint256) {
        return 0;
    }

    //获取策略列表
    function getStrategies() external view override returns (address[] memory) {
        return new address[](0);
    }
}
