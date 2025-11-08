# TokenSwap - 多DEX最优路径交换合约

这是一个基于 Hardhat 3 Beta 开发的智能合约项目，实现了通过多个DEX进行代币交换的最优路径查找功能。该项目使用 OpenZeppelin 库，并遵循最佳实践。

## 项目概述

TokenSwap 是一个智能合约系统，允许用户在不同的去中心化交易所（DEX）之间进行代币交换，并自动找到最优的交换路径。该系统具有以下特点：

- 合约本身不持有流动性池，而是与外部DEX进行交互
- 能够计算任意代币到USDT（可配置）的最短最优路径，默认交换次数不超过4次（可配置）
- 设计可插拔的DEX接口，目前实现了Uniswap V3和V4
- 使用OpenZeppelin库确保安全性和最佳实践

## 合约架构

### IDexRouter

这是所有DEX路由器必须实现的顶层接口，定义了交换代币和获取报价的基本方法。

### UniswapV3Router

实现了IDexRouter接口，用于与Uniswap V3进行交互。

### UniswapV4Router

实现了IDexRouter接口，用于与Uniswap V4进行交互（简化实现，因为V4仍在开发中）。

### PathFinder

负责查找最优交换路径的合约，可以根据不同的DEX和交换次数限制找到最佳路径。

### TokenSwap

主合约，整合了所有功能，提供用户交互接口。

## 安装和部署

### 安装依赖

```shell
npm install
```

### 编译合约

```shell
npx hardhat compile
```

### 部署合约

```shell
npx hardhat run scripts/deploy.ts --network <network-name>
```

## 使用说明

### 添加DEX路由器

合约所有者可以添加新的DEX路由器：

```solidity
await tokenSwap.addDexRouter("DEX名称", "路由器地址");
```

### 交换到目标代币

用户可以将任意代币交换到目标代币（默认为USDT）：

```solidity
await tokenSwap.swapToTarget(
  "输入代币地址",
  "输入数量",
  "最小输出数量",
  "截止时间"
);
```

## 安全性

本项目使用OpenZeppelin库，并实现了以下安全措施：

- 使用`Ownable`模式限制关键功能只能由合约所有者调用
- 使用`ReentrancyGuard`防止重入攻击
- 所有交换操作都有最小输出金额和截止时间保护
- 使用`transferFrom`和`approve`模式确保代币安全转移

## 许可证

本项目采用MIT许可证。

## 贡献

欢迎提交问题报告和功能请求。如果您想贡献代码，请先创建一个问题来讨论您想要实现的功能。
