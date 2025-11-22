import { expect } from "chai";
import { network } from "hardhat";

const { ethers } = await network.connect();

const zeroAddress = "0x0000000000000000000000000000000000000000";



const tokenAddrOnSepolia = {
  UNI: "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984",
  AAVE: "0x88541670E55cC00bEEFD87eB59EDd1b7C511AC9a",
  LINK: "0xf8Fb3713D459D7C1018BD0A49D19b4C44290EBE5",
  WETH9: "0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14",
  USDT: "0xaA8E23Fb1079EA71e0a56F48a2aA51851D8433D0",
}

const contractAddressOnSepolia = {
  PathFinder: "0xd50Ba962E7d2B043797566a3d91Ff6B44Cb68c6E",
  TokenSwap: "0x70314b0E68f13DCB1D427F74Fecc41A88dDE9E52",
  UniswapV3Router: "0x4917E5BA809F8eA2D02a16707b5b68284285DC6d",
}

const uniswapV3SwapRouterAddress = "0x3bFA4769FB09eefC5a80d6E87c3B9C650f7Ae48E";
const uniswapV3QuoterV2Address = "0xEd1f6473345F45b75F8179591dd5bA1888cf2FB3";
const uniswapV3FactoryAddress = "0x0227628f3F023bb0B980b67D528571c95c6DaC1c";


describe("UniswapV3Router sepolia test", function () {


  it("UniswapV3Router getAmountsOut", async function () {
    // const uniswapV3Router = await ethers.getContractAt("UniswapV3Router", contractAddressOnSepolia.UniswapV3Router);
    const PathFinder = await ethers.getContractAt("PathFinder", contractAddressOnSepolia.PathFinder);

    const amountIn = ethers.parseUnits("1.0", 18); // 1 ETH
    // const result = await uniswapV3Router.findOptimalPath.staticCall(zeroAddress, amountIn, tokenAddrOnSepolia.USDT, 4);
    const result = await PathFinder.findOptimalPath.staticCall(tokenAddrOnSepolia.WETH9, amountIn);
    console.log("最优路径结果:", result);

    const USDTToken = await ethers.getContractAt("MockERC20", tokenAddrOnSepolia.USDT);
    const USDTDecimals = await USDTToken.decimals.staticCall();
    console.log("USDT Decimals:", USDTDecimals);
    console.log("1 ETH 最多换到的 USDT:", ethers.formatUnits(result[2], USDTDecimals));

    expect(result[0][0]).to.equal(tokenAddrOnSepolia.WETH9);
    expect(result[0][1]).to.equal(tokenAddrOnSepolia.USDT);

    const quoter = await ethers.getContractAt("MockUniswapV3Quoter", uniswapV3QuoterV2Address);
    const pathBytes = ethers.solidityPacked(
      ["address", "uint24", "address"],
      [tokenAddrOnSepolia.WETH9, 3000, tokenAddrOnSepolia.USDT]
    );
    const quoterRes = await quoter.quoteExactInput.staticCall(pathBytes, amountIn);
    console.log("quoter getAmountsOut result2:", quoterRes);
    console.log("quoter 1 ETH 最多换到的 USDT:", ethers.formatUnits(quoterRes[0], 6));
    expect(result[2]).to.be.eq(quoterRes[0]);
  })

  it("IDexRouter swapTokensForTokens UNI->USDT", async function () {
    const signers = await ethers.getSigners();
    const account = signers[0];

    const uniAmountIn = ethers.parseUnits("0.0001", 18);
    // 获取路径 (tokenIn + fee + tokenOut)
    const tokenSwap = await ethers.getContractAt("TokenSwap", contractAddressOnSepolia.TokenSwap);
    const swapInfo = await tokenSwap.getSwapToTargetQuote.staticCall(tokenAddrOnSepolia.UNI, uniAmountIn);
    // swapInfo 返回的是一个数组，需要转换为对象
    const swapInfoObj = {
      path: [...swapInfo[0]],
      pathBytes: swapInfo[1],
      outputAmount: swapInfo[2],
      inputAmount: swapInfo[3],
      dexRouter: swapInfo[4],
    };
     // 设置交易参数
    let params = {
      path: swapInfoObj,
      tokenIn: tokenAddrOnSepolia.UNI,
      amountIn: swapInfo.inputAmount, // 0.01 UNI
      amountOutMin: 0, // 最小输出数量（这里设置为0，实际使用时应该设置合理的最小值）
      to: await account.getAddress(),
      deadline: Math.floor(Date.now() / 1000) + 60 * 10 // 10分钟后过期
    }
    console.log("交易参数:", params);

    // 检查余额和授权
    const uniToken = await ethers.getContractAt("MockERC20", tokenAddrOnSepolia.UNI);
    const uniBalance = await uniToken.balanceOf(params.to)
    console.log(`UNI余额:`, ethers.formatUnits(uniBalance, 18));
    const allowance = await uniToken.allowance(params.to, swapInfoObj.dexRouter,);
    // 获取交易前的USDT余额
    const usdtToken = await ethers.getContractAt("MockERC20", tokenAddrOnSepolia.USDT);
    const usdtBalanceBefore = await usdtToken.balanceOf(params.to);
    console.log(`交易前USDT余额:`, ethers.formatUnits(usdtBalanceBefore, 6));
    // 检查授权
    if (allowance < uniAmountIn) {
      console.log("需要授权...");
      const approveTx = await uniToken.approve(swapInfoObj.dexRouter, uniAmountIn);
      await approveTx.wait();
      console.log("授权完成");
    }
   
    console.log("执行兑换...");
        // 调用 exactInput 方法
    const dexRouter = await ethers.getContractAt("IDexRouter", swapInfoObj.dexRouter);
    const tx = await dexRouter.swapTokensForTokens(...Object.values(params),
      {
        gasLimit: 3000000, // 设置合适的 gas limit
        gasPrice: ethers.parseUnits("20", "gwei")
      }
    );
    await tx.wait();
    console.log("交易已发送，等待确认...");
    console.log("交易成功！");
    console.log("交易哈希:", tx.hash);

    // 获取交易后的余额
    const uniBalanceAfter = await uniToken.balanceOf(params.to);
    const usdtBalanceAfter = await usdtToken.balanceOf(params.to);
    console.log(`交易后UNI余额:`, ethers.formatUnits(uniBalanceAfter, 18));
    console.log(`交易后USDT余额:`, ethers.formatUnits(usdtBalanceAfter, 6));
    console.log(`UNI支出:`, ethers.formatUnits(params.amountIn, 18));
    console.log(`USDT获得:`, ethers.formatUnits(usdtBalanceAfter - usdtBalanceBefore, 6));
    expect(usdtBalanceAfter).to.be.gt(usdtBalanceBefore);
  })
 
  it("IDexRouter swapTokensForTokens ETH->USDT", async function () {
    const signers = await ethers.getSigners();
    const account = signers[0];

    const ethAmountIn = ethers.parseUnits("0.01", 18);
    // 获取路径 (tokenIn + fee + tokenOut)
    const tokenSwap = await ethers.getContractAt("TokenSwap", contractAddressOnSepolia.TokenSwap);
    const swapInfo = await tokenSwap.getSwapToTargetQuote.staticCall(zeroAddress, ethAmountIn);
    // swapInfo 返回的是一个数组，需要转换为对象
    const swapInfoObj = {
      path: [...swapInfo[0]],
      pathBytes: swapInfo[1],
      outputAmount: swapInfo[2],
      inputAmount: swapInfo[3],
      dexRouter: swapInfo[4],
    };
     // 设置交易参数
    let params = {
      path: swapInfoObj,
      tokenIn: tokenAddrOnSepolia.WETH9,
      amountIn: swapInfo.inputAmount, // 0.01 UNI
      amountOutMin: 0, // 最小输出数量（这里设置为0，实际使用时应该设置合理的最小值）
      to: await account.getAddress(),
      deadline: Math.floor(Date.now() / 1000) + 60 * 10 // 10分钟后过期
    }
    console.log("交易参数:", params);

    // 获取交易前的USDT余额
    const usdtToken = await ethers.getContractAt("MockERC20", tokenAddrOnSepolia.USDT);
    const usdtBalanceBefore = await usdtToken.balanceOf(params.to);
    console.log(`交易前USDT余额:`, ethers.formatUnits(usdtBalanceBefore, 6));
   
    console.log("执行兑换...");
        // 调用 exactInput 方法
    const dexRouter = await ethers.getContractAt("IDexRouter", swapInfoObj.dexRouter);
    const tx = await dexRouter.swapTokensForTokens(...Object.values(params),
      {
        value: params.amountIn,
        gasLimit: 3000000, // 设置合适的 gas limit
        gasPrice: ethers.parseUnits("20", "gwei")
      }
    );
    await tx.wait();
    console.log("交易已发送，等待确认...");
    console.log("交易成功！");
    console.log("交易哈希:", tx.hash);

    // 获取交易后的余额
    const usdtBalanceAfter = await usdtToken.balanceOf(params.to);
    console.log(`交易后USDT余额:`, ethers.formatUnits(usdtBalanceAfter, 6));
    console.log(`eth支出:`, ethers.formatUnits(params.amountIn, 18));
    console.log(`USDT获得:`, ethers.formatUnits(usdtBalanceAfter - usdtBalanceBefore, 6));
    expect(usdtBalanceAfter).to.be.gt(usdtBalanceBefore);
  })
});
