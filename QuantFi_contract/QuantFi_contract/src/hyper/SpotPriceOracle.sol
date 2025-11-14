// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 导入 L1Read 合约
import "./L1Read.sol";

contract SpotPriceOracleReader is L1Read {
    // 添加 USDC 现货价格相关存储
    mapping(uint32 => uint256) public latestSpotPrices;
    event SpotPriceUpdated(uint32 indexed spotIndex, uint256 price);

    /**
     * @dev 更新现货资产价格
     * @param spotIndex 现货资产索引
     * @return 具有 18 个小数位的转换后的价格
     */
    function updateSpotPrice(uint32 spotIndex) public returns (uint256) {
        // 假设 L1Read 合约中有获取现货价格的函数
        // 你需要根据实际的 L1Read 合约接口进行调整
        uint64 rawPrice = spotPx(spotIndex); // 假设有这样的函数

        // 获取资产信息（可能需要 spotAssetInfo 函数）
        TokenInfo memory assetInfo = tokenInfo(spotIndex); // 假设有这样的函数
        uint8 decimals = assetInfo.szDecimals; // 假设现货资产信息结构体中有 decimals 字段

        // 转换价格到 18 位小数
        uint256 divisor = 10 ** (6 - decimals);
        uint256 convertedPrice = (uint256(rawPrice) * 1e18) / divisor;

        latestSpotPrices[spotIndex] = convertedPrice;
        emit SpotPriceUpdated(spotIndex, convertedPrice);

        return convertedPrice;
    }
}
