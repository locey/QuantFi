// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 导入 L1Read 合约
import "./L1Read.sol";

contract PerpPriceOracleReader is L1Read {
    // 映射以存储每个永续资产索引的最新价格
    mapping(uint32 => uint256) public latestPrices;

    // 映射以存储资产名称
    mapping(uint32 => string) public assetNames;

    // 价格更新事件
    event PriceUpdated(uint32 indexed perpIndex, uint256 price);

    /**
     * @dev 更新永续资产的价格
     * @param perpIndex 永续资产的索引
     * @return 具有 18 个小数位的转换后的价格
     */
    function updatePrice(uint32 perpIndex) public returns (uint256) {
        // 使用继承的函数获取原始预言机价格
        uint64 rawPrice = oraclePx(perpIndex);

        // 使用继承的函数获取资产信息
        PerpAssetInfo memory assetInfo = perpAssetInfo(perpIndex);
        uint8 szDecimals = assetInfo.szDecimals;

        // 存储资产名称
        assetNames[perpIndex] = assetInfo.coin;

        // 转换价格：price / 10^(6 - szDecimals) * 10^18
        // 将原始价格转换为具有 18 个小数位的可读价格
        uint256 divisor = 10 ** (6 - szDecimals);
        uint256 convertedPrice = (uint256(rawPrice) * 1e18) / divisor;

        // 存储转换后的价格
        latestPrices[perpIndex] = convertedPrice;

        // 发出事件
        emit PriceUpdated(perpIndex, convertedPrice);

        return convertedPrice;
    }

    /**
     * @dev 获取永续资产的最新价格
     * @param perpIndex 永续资产的索引
     * @return 具有 18 个小数位的最新转换后的价格
     */
    function getLatestPrice(uint32 perpIndex) public view returns (uint256) {
        return latestPrices[perpIndex];
    }
}
