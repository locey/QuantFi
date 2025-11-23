// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IAssetsAdapter {
    // 资产注入操作
    function addAssets(address _token, uint256 _amount) external;
    //资产移除操作
    function removeAssets(address _token) external;
}
