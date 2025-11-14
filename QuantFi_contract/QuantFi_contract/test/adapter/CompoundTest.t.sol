// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../../src/adapters/CompoundAdapter.sol";
import "../../src/mock/MockCompound.sol";
import "../../src/mock/MockERC20.sol";
import "../../src/interfaces/IDefiAdapter.sol";
import "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract CompoundTest is Test {
    address public owner;
    address public deployer;
    address public user1;
    address public user2;
    MockERC20 public underlyingToken;
    CompoundAdapter public compoundAdapter;
    MockCToken public cToken;

    function setUp() public {
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        deployer = makeAddr("deployer");
        vm.startPrank(deployer);
        //精度按照18算，暂不用6
        underlyingToken = new MockERC20("USDC", "USDC", 18);
        cToken = new MockCToken(
            "cToken",
            "cToken",
            address(underlyingToken),
            1e18
        );
        CompoundAdapter impl = new CompoundAdapter();
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(impl),
            abi.encodeWithSelector(
                CompoundAdapter.initialize.selector,
                address(cToken),
                address(underlyingToken),
                owner
            )
        );

        compoundAdapter = CompoundAdapter(address(proxy));

        //初始化测试数据
        _initTestData();
        vm.stopPrank();
    }

    function testDepositAndWithdraw() public {
        console.logString("====== COMPOUND TEST START ======");

        // 第一次存款
        console.logString("[DEPOSIT] First Deposit Amount: 5000");
        _exexcuteDeposit(5000);

        //  第二次存款
        console.logString("[DEPOSIT] Second Deposit Amount: 5000");
        _exexcuteDeposit(5000);

        //模拟借贷协议中放贷收回利息的操作
        uint256 interestAmount = ((5000 + 5000) * 8) / 100;
        console.logString("[INTEREST] Simulated Interest Amount:");
        console.logUint(interestAmount);
        underlyingToken.mint(address(compoundAdapter), interestAmount);

        // 第一次提现
        console.logString("[WITHDRAW] First Withdraw Amount: 5000");
        _exexcuteWithdraw(5000);

        // 第两次提现(适配器合约收取手续费，能提现的金额小于5000)
        console.logString("[WITHDRAW] Second Withdraw Amount: withdrawAmount");
        //适配器中的手续费是0.3%
        uint256 cTokenAmount = IERC20(address(cToken)).balanceOf(user1);

        //转换成underlying可提取的最大额度
        uint256 withdrawAmount = (cTokenAmount * 1e18) /
            cToken.exchangeRateCurrent();
        _exexcuteWithdraw(withdrawAmount);

        console.logString("====== COMPOUND TEST PASSED ======");
    }

    // 执行存款
    function _exexcuteDeposit(uint256 amount) internal {
        console.logString("====== DEPOSIT EXECUTION ======");
        vm.startPrank(user1);

        // 打印存款前的余额
        uint256 userUnderlyingBalanceBefore = underlyingToken.balanceOf(user1);
        uint256 userCTokenBalanceBefore = cToken.balanceOf(user1);
        console.logString("[BALANCE] User USDC Balance (Before):");
        console.logUint(userUnderlyingBalanceBefore);
        console.logString("[BALANCE] User cToken Balance (Before):");
        console.logUint(userCTokenBalanceBefore);

        OperationParams memory params;
        params.amounts = new uint256[](1);
        params.amounts[0] = amount;
        params.tokens = new address[](1);
        params.tokens[0] = address(underlyingToken);
        params.recipient = user1;
        params.deadline = block.timestamp + 100;
        params.operationType = OperationType.DEPOSIT;
        uint24 feeRateBps = 30;

        //授权给合约对应数量的代币
        console.logString("[APPROVE] Approving USDC to CompoundAdapter:");
        console.logUint(amount);
        underlyingToken.approve(address(compoundAdapter), amount);

        OperationResult memory result = compoundAdapter.executeOperation(
            params,
            feeRateBps
        );

        // 打印存款后的余额
        uint256 userUnderlyingBalanceAfter = underlyingToken.balanceOf(user1);
        uint256 userCTokenBalanceAfter = cToken.balanceOf(user1);
        console.logString("[BALANCE] User USDC Balance (After):");
        console.logUint(userUnderlyingBalanceAfter);
        console.logString("[BALANCE] User cToken Balance (After):");
        console.logUint(userCTokenBalanceAfter);

        assertEq(result.success, true, "Deposit operation should succeed");
        console.logString("====== DEPOSIT EXECUTION PASSED ======");
        vm.stopPrank();
    }

    // 执行提现
    function _exexcuteWithdraw(uint256 amount) internal {
        console.logString("====== WITHDRAW EXECUTION ======");
        vm.startPrank(user1);

        // 打印提现前的余额
        uint256 userUnderlyingBalanceBefore = underlyingToken.balanceOf(user1);
        uint256 userCTokenBalanceBefore = cToken.balanceOf(user1);
        console.logString("[BALANCE] User USDC Balance (Before):");
        console.logUint(userUnderlyingBalanceBefore);
        console.logString("[BALANCE] User cToken Balance (Before):");
        console.logUint(userCTokenBalanceBefore);

        OperationParams memory params;
        params.amounts = new uint256[](1);
        params.amounts[0] = amount;
        params.tokens = new address[](1);
        params.tokens[0] = address(underlyingToken);
        params.recipient = user1;
        params.deadline = block.timestamp + 100;
        params.operationType = OperationType.WITHDRAW;
        uint24 feeRateBps = 30;

        // 授权cToken给adapter
        // 将amount转成cToken的数量
        uint256 exchangeRate = cToken.exchangeRateCurrent();
        uint256 cTokenAmount = (amount * 1e18) / exchangeRate;
        console.logString("[EXCHANGE] Exchange Rate:");
        console.logUint(exchangeRate);
        console.logString("[EXCHANGE] Required cToken Amount:");
        console.logUint(cTokenAmount);

        console.logString("[APPROVE] Approving cToken to CompoundAdapter:");
        console.logUint(cTokenAmount);
        cToken.approve(address(compoundAdapter), cTokenAmount);

        OperationResult memory result = compoundAdapter.executeOperation(
            params,
            feeRateBps
        );

        // 打印提现后的余额
        uint256 userUnderlyingBalanceAfter = underlyingToken.balanceOf(user1);
        uint256 userCTokenBalanceAfter = cToken.balanceOf(user1);
        console.logString("[BALANCE] User USDC Balance (After):");
        console.logUint(userUnderlyingBalanceAfter);
        console.logString("[BALANCE] User cToken Balance (After):");
        console.logUint(userCTokenBalanceAfter);

        assertEq(result.success, true, "Withdraw operation should succeed");
        console.logString("====== WITHDRAW EXECUTION PASSED ======");
        vm.stopPrank();
    }

    function _initTestData() internal {
        // mint USDC to user1
        console.logString(
            "[INIT] Initializing test data: Minting USDC to user1:"
        );
        console.logUint(1000 * 1e6);
        underlyingToken.mint(user1, 1000 * 1e6);
        console.logString("[INIT] User1 USDC Balance:");
        console.logUint(underlyingToken.balanceOf(user1));
    }
}
